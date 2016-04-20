require 'cairo'

module Yuimaru
  class Sequence
    class Diagram
      HAND_FAMILY = 'Daniel'

      attr_reader :surface, :context, :width, :height

      def initialize(sequence)
        @sequence = sequence
        @width = 300
        @height = 200
      end

      def draw
        init_surface
        init_context
        set_font
        fill_background
        show_sample_text

        yield surface
      end

      private

      def init_surface
        format = Cairo::FORMAT_ARGB32
        @surface = Cairo::ImageSurface.new(format, width, height)
      end

      def init_context
        @context = Cairo::Context.new(@surface)
      end

      def set_font(family: HAND_FAMILY, font_size: 16)
        context.font_face = Cairo::ToyFontFace.new(family)
        context.font_size = font_size
      end

      def fill_background
        context.fill do
          context.set_source_rgb(1, 1, 1)
          context.rectangle(0, 0, width, height)
        end
      end

      def show_sample_text
        text = 'sample'
        te = context.text_extents(text)
        text_x = width / 2 - te.width / 2
        text_y = height / 2 - te.height / 2
        context.move_to(text_x, text_y)
        context.set_source_rgb(0, 0, 0)
        context.show_text(text)

        context.stroke do
          margin = te.height
          rectangle_x = width / 2 - te.width / 2 - margin
          rectangle_y = height / 2 - te.height / 2 - margin
          rectangle_width = te.width + margin * 2
          rectangle_height = te.height + margin
          context.rectangle(rectangle_x, rectangle_y, rectangle_width, rectangle_height)
        end
      end
    end
  end
end
