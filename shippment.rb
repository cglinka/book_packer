require 'json'

class Shippment
  attr_reader :shippment

  def create_shippment(items)
    fill_boxes(items)
    shippment_object
    make_json_object
  end

  private

  def does_it_fit?(book, box)
    max_weight = 10
    book + box <= max_weight
  end

  def fill_boxes(items)
    # Sort the items by weight, hightest weight first.
    items.sort_by! { |item| item["weight"]}
    items.reverse!
    puts "packing #{items.length} books"

    # Nested Array. Entire shipment, with each box an array inside the shipment.
    @boxes = [[]]
    @box_weights = [0.0]

    items.each do |item|
      box_counter = 0
      while box_counter < @box_weights.length
        if does_it_fit?(item["weight"], @box_weights[box_counter])
          # Add item to box
          @boxes[box_counter] << item
          # Add weight of item to total box weight
          @box_weights[box_counter] += item["weight"]
          break
        else
          box_counter += 1
        end
      end

      if box_counter == @boxes.length
        # Add a new box
        @box_weights << 0.0
        @boxes << []

        # Add item to box
        @boxes[box_counter] << item
        # Add weight of item to total box weight
        @box_weights[box_counter] += item["weight"]
      end
    end
  end

  def shippment_object
    @shippment = []
    i = 0
    while i < @boxes.length
      box_wrapper = { "box" =>
        {
        "id" => i + 1,
        "total_weight" => "#{@box_weights[i]} pounds",
        "contents" => @boxes[i]
        }
      }
      @shippment << box_wrapper
      i += 1
    end
    return @shippment
  end

  def make_json_object
    @shippment.to_json
  end
end