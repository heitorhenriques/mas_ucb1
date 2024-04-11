package example;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import java.util.List;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.DefaultCategoryDataset;

public class Graph extends JFrame {

  private static final long serialVersionUID = 1L;
  private static DefaultCategoryDataset dataset;

  // Função para iniciar o gráfico
  // Cria uma nova tela e printa o gráfico vazio
  public static void startGraph(List<Double> avgTimes) {
    SwingUtilities.invokeLater(() -> {
      Graph example = new Graph("UCB1", avgTimes);
      example.pack();
      example.setSize(600, 400);
      example.setVisible(true);
    });
  }

  public Graph(String title, List<Double> avgTimes) {
    super(title);
    // Create dataset
    dataset = new DefaultCategoryDataset();

    // Create chart
    JFreeChart chart = ChartFactory.createLineChart(
        "UCB1 Convergence", // Chart title
        "Date", // X-Axis Label
        "Average Time", // Y-Axis Label
        dataset);

    ChartPanel panel = new ChartPanel(chart);
    setContentPane(panel);
  }

  // private DefaultCategoryDataset createDataset() {
  //   String series1 = "Average Times";
  //   String series2 = "Unique Visitor";

  //   DefaultCategoryDataset dataset = new DefaultCategoryDataset();

  //   dataset.addValue(200, series1, "2016-12-19");
  //   dataset.addValue(150, series1, "2016-12-20");
  //   dataset.addValue(100, series1, "2016-12-21");
  //   dataset.addValue(210, series1, "2016-12-22");
  //   dataset.addValue(240, series1, "2016-12-23");
  //   dataset.addValue(195, series1, "2016-12-24");
  //   dataset.addValue(245, series1, "2016-12-25");

  //   dataset.addValue(150, series2, "2016-12-19");
  //   dataset.addValue(130, series2, "2016-12-20");
  //   dataset.addValue(95, series2, "2016-12-21");
  //   dataset.addValue(195, series2, "2016-12-22");
  //   dataset.addValue(200, series2, "2016-12-23");
  //   dataset.addValue(180, series2, "2016-12-24");
  //   dataset.addValue(230, series2, "2016-12-25");

  //   return dataset;
  // }

  public static void updateData(List<Double> newData) {
    String series1 = "Average Times";
    // Get current timestamp (optional)
    // String timestamp = ...; // Get current date/time
    for (int i = 0; i < newData.size(); i++) {
      Double value = newData.get(i);
      dataset.addValue(value, series1, "haha"); // Update with timestamp if needed
    }
  }
  
}