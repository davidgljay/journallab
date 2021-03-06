module AnalysisHelper


  # Creates an array of days from "start" to "finish"
  # This code appears in Pages Helper and Pages Controller, is there a way to DRY across these two?

  def dayrange(start, finish)
    if start > finish
      s = start
      start = finish
      finish = s
    end
    days = [start]
    day = start + 1.day
    while day <= finish
      days << day
      day += 1.day
    end
    days
  end

# Accepts arrays of the form [[title1,[[x,y],[x,y]]],[title2,[[x,y],[x,y]]]

  def day_line_graph(array)
    start = array.map{|a| a[1].map{|coord| coord[0]}.min}.min
    finish = array.map{|a| a[1].map{|coord| coord[0]}.max}.max
    # First, get the full range of days covered by the graph
    range = dayrange(start, finish)
    # Then, create arrays of the form [day, value1, value2]
    series = []
    range.each do |day|
      d = [day]
      array.each do |a|
        y = a[1].select{|coord| coord[0] == day}[0]
        if y.nil?
          d << 0
        else
          d << y[1]
        end
      end
      series << d
    end
    name = array.map{|a| a[0]} * "_"
    output =     "<script type=\"text/javascript\" src=\"http://www.google.com/jsapi\"></script>
    <script type=\"text/javascript\">
      google.load('visualization', '1', {packages: ['corechart']});
    </script>
    <script type=\"text/javascript\">
      function drawVisualization() {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
         data.addColumn('string', 'Date');"
    # Add the names of each value.
    array.each do |a|
      output << "data.addColumn('number', '" + a[0] + "');\n"
    end
    # Add the coordinates
    series.each do |coord|
      output << "data.addRow(['" + coord[0].strftime("%D") + "'," + coord.drop(1) * "," + "]);\n"
    end
    output <<
        " // Create and draw the visualization.
       new google.visualization.LineChart(document.getElementById('" + name + "')).
         draw(data, {curveType: \"none\",
                  width: 700, height: 500,
                  vAxis: {maxValue: 1}}
         );
       }

      google.setOnLoadCallback(drawVisualization);
    </script>
    <div id=\"" + name + "\" style=\"width: 700px; height: 500px;\"></div>"
    output.html_safe
  end

#Creates a bar graph of a histogram. For now the graph only supports one variable.

  def bar_graph(array, unit_name)
    name = unit_name.gsub(' ', '_')
    output =     "<script type=\"text/javascript\" src=\"http://www.google.com/jsapi\"></script>
    <script type=\"text/javascript\">
      google.load('visualization', '1', {packages: ['corechart']});
    </script>
    <script type=\"text/javascript\">
      function drawVisualization() {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
         data.addColumn('string', 'numbers');
         data.addColumn('number', '" + unit_name + "');\n"
    array.each do |coord|
      output << "data.addRow(['" + coord[0].to_s + "'," + coord[1].to_s + "]);\n"
    end
    output <<
        " // Create and draw the visualization.
        new google.visualization.ColumnChart(document.getElementById('" + name + "')).
            draw(data,
                 {title:\"" + unit_name + "\",
                  width:500, height:400,
                  legend: 'none'}
            );
      }


      google.setOnLoadCallback(drawVisualization);
    </script>
    <div id=\"" + name + "\" style=\"width: 500px; height: 400px;\"></div>"
    output.html_safe
  end
end
