YooAye
======

Try it
------

When:

    #controller:
    helper YooAyHelper

    #view
    - @numbers = %w(one two three)

    = ui.list @numbers do |l|
      - l.item do |number, index, attributes|
        - attributes.classes << "item-#{number}"
        .abc
          = (index + 1).ordinalize
        .def
          = number.humanize

Then:

    <ul>
      <li class="item-one">
        <div class='abc'>
          1st
        </div>
        <div class='def'>
          One
        </div>
      </li>
      <li class="item-two">
        <div class='abc'>
          2nd
        </div>
        <div class='def'>
          Two
        </div>
      </li>
      <li class="item-three">
        <div class='abc'>
          3rd
        </div>
        <div class='def'>
          Three
        </div>
      </li>
    </ul>

### More to come