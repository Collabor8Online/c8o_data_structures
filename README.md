# DataStructures
Define structures consisting of various collections of "fields"

They are split in to two parts: templates, holding items, which define the structure for containers, holding values.  

Items within a template are either individual fields or containers, which hold more items.  

A simple structure could be a flat list of fields - [in this case](/spec/examples/simple_template.yml), a text field, a rich-text field and a date field:
```yaml
version: 1
name: Simple template
description: My simple template
type: template 
items:
  - type: text
    caption: What's your name?
    required: true 
  - type: rich_text
    caption: Tell me about yourself
  - type: date 
    caption: What's your date of birth?
```
A more complex hierarchy could consist of sections that hold more fields, and groups.  In this [order form](/spec/examples/fancy_order_form.yml) the repeating group will allow the resulting container to have multiple "Item to order", "Quantity" and "Reason for order" values.  
```yaml
version: 1
name: Fancy order form
description: Order multiple items
type: template 
items:
  - type: section
    items:
      - type: heading
        text: Order form
      - type: sub_heading
        text: Personal details
      - type: text
        caption: Your name
        required: true 
  - type: section
    items:
      - type: heading
        text: Order details
      - type: repeating_group
        items:
          - type: text
            caption: Item to order
            required: true 
          - type: number
            caption: Quantity
            required: true 
            default: 1
            minimum: 1
          - type: rich_text
            caption: Reason for order
  - type: section
    items:
      - type: date 
        caption: Date
        required: true 
        default: today 
      - type: signature
        caption: Sign here
        required: true 
```
Templates are not stored in a database - instead they are built from a configuration hash, so you can choose where to store them and load them using `DataStructures.load(hash)`

Templates can then be used to build a container of values.  The container itself is an ActiveRecord model from your application that includes the `DataStructures::Container` module.  When you call `#create_values_for(template)` values are attached to the container, each taking its definition from the items within the template.  

## Usage
How to use my plugin.

## Installation
Add the gem to your application's Gemfile:

```ruby
gem "c8o_data_structures"
```

And then install:
```bash
bundle
```

Finally copy the migrations to your database: 
```bash

```

## License
The gem is available as open source under the terms of the [LGPL License](/LICENSE).
