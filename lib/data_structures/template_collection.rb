module DataStructures
  class TemplateCollection
    include Plumbing::Actor

    async :[], :set, :load

    def initialize(configuration)
      @configuration = configuration
      @templates = {}
    end

    private

    def load config = {}
      DataStructures::Definition.load(config).tap do |template|
        set template.name, template
      end
    end

    def set name, template
      @templates[name.to_s] = template
    end

    def [] name
      @templates[name.to_s]
    end
  end
end
