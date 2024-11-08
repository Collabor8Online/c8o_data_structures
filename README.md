# DataStructures

Reusable, and modifiable, database-backed data structures that can be added into your applications.  

Intended use-cases include: 
- adding "user-defined" fields to your application; so administrators can define extra metadata to be stored alongside your own models
- custom forms; design form templates that can easily be modified and then, once filled in, stored in your database

There are two "sides" to the DataStructures gem - the "data" side and the "definition" side.  Think of it as the relationship between a class and an instance of that class - the class defines the structure and behaviour while the instances hold actual data and respond to the environment around them.  

The "definition" is used to define the structure of your data.  It has a "DataStructures::Definition::Template" at its root and holds a number of objects in a hierarchy.  The definition is designed to be built from a Hash, so it can be easily modified using JSON or YAML configuration files (or stored in your database as a `serialize`d field).  

The "data" side uses a definition to create a hierarchy of "fields" which store actual data that is attached to a model record inside your application's database.  

We'll use two examples - a very simple "SupportRequest"[^1], where the template defines a simple collection of fields, and an "OrderForm", where the template is hierarchical and allows the end-user to add in multiple, repeating, items.  Currently they are not there, but they will be added in to the [test application](/spec/test_app) with [RSpec examples](/spec/examples).

## Glossary

- Configuration - this is the Hash that is used to build the definition - allowing templates to be stored in a variety of ways; as a serialised field within an ActiveRecord model, or from JSON or YAML configuration files.  
- Path - because definitions and data can be hierarchical, instead of simply referring to "field names", we refer to a "field path".  These work slightly differently on the definition and data sides (because of repeating groups), but both represent a way to identify and locate an individual element within the data structure.  
- [DataStructures::Container](/app/models/concerns/data_structures/container.rb) - your model that holds the definition for your template, as well as the data associated with the container (internally this uses a [DataStructures::Template](/app/models/data_structures/template.rb) to store the configuration and [DataStructures::Fields](/app/models/data_structures/field.rb) to store the data)
- [DataStructures::Field](/app/models/data_structures/field.rb) - a model that stores the actual values for an instance of your template; for example, the "answers" that a user supplies when filling out a form
- [DataStructures::Definition::Template](/lib/data_structures/definition/template.rb) - an object that sits at the root of your data structure definition
- [DataStructures::Definition::Field](/lib/data_structures/definition/field.rb) - an object that defines a data-type that sits inside your data structure
- [DataStructures::Definition::Section](/lib/data_structures/definition/section.rb) - an object that represents a collection of data-types
- [DataStructures::Definition::RepeatingGroup](/lib/data_structures/definition/repeating_group.rb) - an object that represents a collection of data-types that can be added multiple times on the data side[^2]

A key principle of the gem is that we try to put as much work into the definitions side as possible, so the data side can remain simple[^3].

## Usage

### Support Request example: a simple collection of fields

Your application wants to allow users to post support requests to your support team.  Even though the requirement is currently simple, there is a high chance that it will grow in complexity in the future, so you opt to use a template, allowing you to extend and update the requests as requirements change with no database migrations required.  

In your application, you add a support request template file in `config/templates/support_request.yml`

```yaml
name: Support Request
description: Got a problem?  Let us know!
items:
  - type: text
    caption: Your name
    required: true 
  - type: email
    caption: Your email address
    required: true 
  - type: drop_down
    caption: How urgent is it?
    required: true
    options:
      '0': Just a question
      '1': Important
      '2': The sky is falling in        
  - type: rich_text
    caption: How can we help?
```

This is a very simple template, consisting of four field definitions - a text field, an email field, a drop-down and a rich-text field.  

In your application, you add in the controller for support requests[^4]: 

```ruby
class SupportRequestsController < ApplicationController
  def new 
    @support_request = SupportRequest.new(configuration: configuration)
    render action: "new"
  end

  def create 
    @support_request = SupportRequest.create!(support_request_params.merge(configuration: configuration))
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid
    render action: "new"
  end

  private

  def configuration = YAML.load(File.open(Rails.root.join("config", "templates", "support_request.yml"))

  def support_request_params = params.require(:support_request).permit(fields_attributes: [])
end
```

And you define your SupportRequest model:

```ruby
class SupportRquest < ApplicationRecord
  include DataStructures::Container
end
```

Now, when your user visits `/support_requests/new` they see a form representing the support request[^5], built from the YAML file you have defined.  And when they POST that form, your SupportRequest record gets created, along with a collection of `DataStructure::Field` records holding the answers that the user has supplied.  

You can then access the details of the submitted support request, by either looking at the SupportRequest's fields collection, or by accessing fields using their `path`.  

```ruby
@support_request = SupportRequest.find 123

puts @support_request.fields.collect { |f| "#{f.caption}:  #{f.answer}]}.join(", ")
# => Your name: Bob, Your email address: bob@example.com, How urgent is it?: The sky is falling in, How can we help?: You're my only hope 
puts @support_request.field["/your_name"].answer
# => Bob
puts @support_request.field["/how_urgent_is_it"].answer
# => The sky is falling in
puts @support_request.field["/how_urgent_is_it"].value
# => 2
```

## The DataStructures service API

### Data Types

#### Querying the attributes of a field definition

#### Registering field definitions

#### Registering user-interface components

### Collections

### Thread-safety

## Adding new types of field

### The field definition

### The field model

The field model already knows enough to deal with: 
- various primitive data-types 
  - string
  - integer
  - float
  - date
  - date/time
  - time
  - boolean, 
- some complex data-types 
  - file and media attachments using ActiveStorage 
  - rich text fields using ActionText 
  - signatures stored as PNG data URLs
  - geolocation stored as JSON
- types that require options
  - drop-down/selects
  - multi-selects
- types that refer to other ActiveRecord models (stored using a polymorphic association)

So for the most part, you won't need to extend the [DataStructures::Field](/app/models/data_structures/field.rb).  

However, you will need to register new components for editing and possibly displaying your data types.  

## Installation
Add the gem to your application's Gemfile:

```ruby
gem "c8o_data_structures"
```

And then install:
```bash
bundle
```

Copy the migrations to your database: 
```bash
bin/rails whatever:the:rake_task:is
bin/rails db:migrate
bin/rails db:test:prepare
```

Add the [DataStructures::Container](/app/models/concerns/data_structures/container.rb) module to your ActiveRecord models.  
```ruby
class MyModel < ApplicationRecord
  include DataStructures::Container
end
```

## License
The gem is available as open source under the terms of the [LGPL License](/LICENSE).  This may or may not make it suitable for use in your project - contact support@collabor8online.co.uk for further options.  

[^1]: This is an overly simplified example and you'd probably be better off describing a real support request as a traditional ActiveRecord model - but it serves the purpose of describing how fields work.  

[^2]: Unlike a section, a repeating group can be added repatedly on the data side.  In our order form example, we'll see how this can be used to allow users to "add another item" to their order.  The [DataStructures::Definition::Group](/lib/data_structures/definition/group.rb) object is then used internally to manage these items. 

[^3]: This is my third attempt at writing this functionality for [Collabor8Online](https://www.collabor8online.co.uk) and one lesson learnt is that it's much easier to manage a proliferation of data-types on the definition side than it is on the data side.  So we try to give the definition classes all the power and keep the field models as simple as possible.  

[^4]: Loading the configuration file on each request isn't great, but this is just a simple example.  

[^5]: I've not built the generic UI components yet, as I'm still experimenting with them in the [Collabor8Online](https://www.collabor8online.co.uk) application; they will be extracted when they are ready, so you can reuse them as part of this gem.  
