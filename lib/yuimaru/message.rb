module Yuimaru
  class Message < Struct.new(:from, :name, :to)
    def <<(from)
      self.tap {|m| m.from = from }
    end

    def >>(to)
      self.tap {|m| m.to = to }
    end
  end
end
