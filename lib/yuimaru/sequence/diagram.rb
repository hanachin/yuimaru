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

        margin = 16
        current_x = current_y = margin

        actor_margin = 16
        actor_padding = 8
        @actors_pos = {}
        @sequence.actors.each do |a|
          a_te = te[a]
          @actors_pos[a] = {
            x: current_x,
            y: current_y,
            text_x: current_x + actor_padding,
            text_y: current_y + actor_padding + a_te.height,
            width: actor_padding * 2 + a_te.width,
            height: actor_padding * 2 + a_te.height
          }
          current_x += actor_margin + actor_padding * 2 + a_te.width
        end

        current_y = @actors_pos.map {|(a, pos)| pos[:y] + pos[:height] }.max

        @width = current_x - actor_margin + margin
        @height = current_y + margin
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
        @actors_pos.each do |a, pos|
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
