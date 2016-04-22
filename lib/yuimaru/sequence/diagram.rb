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
        draw_lifeline
        draw_messages

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

        @messages_layout = {}
        message_padding = 32
        @sequence.messages.each do |m|
          name_te = te[m.name]
          @messages_layout[m] = {
            text_width: name_te.width,
            text_height: name_te.height,
            width: message_padding * 2 + name_te.width,
            height: message_padding * 2 + name_te.height
          }
        end

        actor_margin = 16
        @sequence.messages.each do |m|
          @actors_layout[m.from][:max_distance] ||= {}
          @actors_layout[m.from][:max_distance][m.to] = [
            @actors_layout[m.from][:max_distance][m.to],
            @messages_layout[m][:width],
            @actors_layout[m.from][:width] / 2 + @actors_layout[m.to][:width] / 2,
            actor_margin
          ].compact.max
        end

        current_x = current_y = actor_margin
        @sequence.actors.each_with_index do |a, i|
          l = @actors_layout[a]
          l[:x] = current_x
          l[:y] = current_y
          l[:text_x] = current_x + actor_padding
          l[:text_y] = current_y + actor_padding + l[:text_height]
          if d = l[:max_distance][@sequence.actors[i + 1]]
            current_x += l[:width] + actor_margin + d
          else
            current_x += l[:width] + actor_margin
          end
        end
        current_y = @actors_layout.map {|(a, pos)| pos[:y] + pos[:height] }.max

        message_margin = 16
        @sequence.messages.each do |m|
          from_l = @actors_layout[m.from]
          to_l = @actors_layout[m.to]
          m_l = @messages_layout[m]

          current_y += [from_l[:text_height], to_l[:text_height]].max
          current_y += message_margin

          m_l[:line_start] = {
            x: from_l[:text_x] + from_l[:text_width] / 2,
            y: current_y + m_l[:text_height]
          }

          m_l[:line_end] = {
            x: to_l[:text_x] + to_l[:text_width] / 2,
            y: current_y + m_l[:text_height]
          }

          m_l[:text_y] = current_y
          m_l[:text_x] = m_l[:line_start][:x] + (m_l[:line_end][:x] - m_l[:line_start][:x]) / 2 - m_l[:text_width] / 2
          current_y += m_l[:text_height]
          current_y += message_margin
        end

        @lifeline_layout = {}
        end_y = @sequence.messages.map {|m| @messages_layout[m][:line_end][:y] }.max
        @sequence.actors.each do |a|
          a_l = @actors_layout[a]
          x = a_l[:text_x] + a_l[:text_width] / 2
          start_y = a_l[:y] + a_l[:height]
          @lifeline_layout[a] = {
            line_start: {x: x, y: start_y},
            line_end:   {x: x, y: end_y}
          }
        end

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

      def draw_lifeline
        dashes = 10
        context.set_dash(dashes)
        @lifeline_layout.each do |_a, pos|
          context.stroke do
            context.set_source_rgb(0, 0, 0)
            context.move_to(pos[:line_start][:x], pos[:line_start][:y])
            context.line_to(pos[:line_end][:x], pos[:line_end][:y] + dashes * 2)
          end
        end
      end

      def draw_messages
        context.set_source_rgb(0, 0, 0)
        context.set_dash(nil)
        @messages_layout.each do |m, pos|
          context.move_to(pos[:text_x], pos[:text_y])
          context.show_text(m.name)
          context.stroke do
            context.move_to(pos[:line_start][:x], pos[:line_start][:y])
            context.line_to(pos[:line_end][:x], pos[:line_end][:y])
          end

          x = pos[:line_end][:x]
          y = pos[:line_end][:y]
          arrow_len = 10
          if pos[:line_end][:x] > pos[:line_start][:x]
            context.stroke do
              context.move_to(x, y)
              context.line_to(x - arrow_len, y - arrow_len)
            end
            context.stroke do
              context.move_to(x, y)
              context.line_to(x - arrow_len, y + arrow_len)
            end
          else
            context.stroke do
              context.move_to(x, y)
              context.line_to(x + arrow_len, y - arrow_len)
            end
            context.stroke do
              context.move_to(x, y)
              context.line_to(x + arrow_len, y + arrow_len)
            end
          end
        end
      end
    end
  end
end
