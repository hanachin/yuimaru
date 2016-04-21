require 'cairo'

module Yuimaru
  class Sequence
    class Diagram
      HAND_FAMILY = 'Daniel'

      attr_reader :surface, :context, :width, :height

      def initialize(sequence)
        @sequence = sequence
      end

      def draw
        set_layout
        init_surface
        init_context
        set_font
        fill_background

        draw_actors

        yield surface
      end

      private

      def set_layout
        s = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, 300, 200)
        c = Cairo::Context.new(s)

        set_font(context: c)

        te = -> (text) { c.text_extents(text) }

        @actors_layout = {}

        actor_padding = 8
        @sequence.actors.each do |a|
          a_te = te[a]
          @actors_layout[a] = {
            text_width: a_te.width,
            text_height: a_te.height,
            width: actor_padding * 2 + a_te.width,
            height: actor_padding * 2 + a_te.height
          }
        end

        @sequence.messages.each do |m|
          name_te = te[m.name]
          @actors_layout[m.from][:max_distance][m.to] = [
            @actors_layout[m.from][:max_distance][m.to],
            name_te.width,
            m.from / 2 + m.to / 2
          ].compact.max
        end

        actor_margin = 16
        current_x = current_y = actor_margin
        @sequence.actors.each do |a|
          l = @actors_layout[a]
          l[:x] = current_x
          l[:y] = current_y
          l[:text_x] = current_x + actor_padding
          l[:text_y] = current_y + actor_padding + l[:text_height]
          current_x += l[:width] + actor_margin
        end
        current_y = @actors_layout.map {|(a, pos)| pos[:y] + pos[:height] }.max
        @width = current_x
        @height = current_y + actor_margin
      end

      def init_surface
        format = Cairo::FORMAT_ARGB32
        @surface = Cairo::ImageSurface.new(format, width, height)
      end

      def init_context
        @context = Cairo::Context.new(@surface)
      end

      def set_font(context: self.context, family: HAND_FAMILY, font_size: 16)
        context.font_face = Cairo::ToyFontFace.new(family)
        context.font_size = font_size
      end

      def fill_background
        context.fill do
          context.set_source_rgb(1, 1, 1)
          context.rectangle(0, 0, width, height)
        end
      end

      def draw_actors
        context.set_source_rgb(0, 0, 0)
        @actors_layout.each do |a, pos|
          context.move_to(pos[:text_x], pos[:text_y])
          context.show_text(a)
          context.stroke do
            context.rectangle(pos[:x], pos[:y], pos[:width], pos[:height])
          end
        end
      end
    end
  end
end
