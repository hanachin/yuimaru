require 'yuimaru/sequence/diagram'

module Yuimaru
  class Sequence
    attr_reader :messages

    def initialize(messages)
      @messages = messages
    end

    def actors
      messages.map {|m| [m.from, m.to] }.flatten.uniq
    end

    def save(path)
      diagram = Diagram.new(self)
      diagram.draw do |surface|
        surface.write_to_png(path)
      end
    end
  end
end
