package example;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;

public class Graph extends JFrame {

  private static final long serialVersionUID = 1L;
  private static List<String[]> csvData; // Data structure to hold CSV data
  private static XYSeries seriesTotal;
  private static XYSeries seriesActions;
  private XYSeriesCollection dataset;
  private static JFreeChart chart;
  private static ChartPanel chartPanel;

  // Função para iniciar o gráfico
  // Cria uma nova tela e printa o gráfico vazio
  public static void startGraph() {
    SwingUtilities.invokeLater(() -> {
      Graph example = new Graph("UCB1");
      example.pack();
      example.setSize(600, 400);
      example.setVisible(true);
    });
  }

  // Cria o gráfico
  public Graph(String title) {
    super(title);

    csvData = new ArrayList<>();
    // Add header to CSV data
    csvData.add(new String[] { "Series", "Iteration", "Average Time (ms)" });

    // Inicia as séries e o dataset
    seriesTotal = new XYSeries("Total Average Time");
    seriesActions = new XYSeries("Current Action Time");
    dataset = new XYSeriesCollection(seriesTotal);
    dataset.addSeries(seriesActions);

    // Cria o gráfico visual
    chart = ChartFactory.createXYLineChart(
        title, // Título
        "Iteration", // X-Axis Label
        "Average Time (ms)", // Y-Axis Label
        dataset,
        PlotOrientation.VERTICAL,
        true, true, false);

    chartPanel = new ChartPanel(chart);
    setContentPane(chartPanel);
  }

  public static void updateData(Double newAvg, Double newValue, String csvName) {
    // Adiciona o novo valor à série
    seriesTotal.add(seriesTotal.getItemCount() + 1, newAvg);
    seriesActions.add(seriesActions.getItemCount() + 1, newValue);

    addToCSVData("Total Average Time", seriesTotal.getItemCount(), newAvg);
    addToCSVData("Current Action Time", seriesActions.getItemCount(), newValue);

    File csvFile = new File("./results/" + csvName + ".csv");
    writeCSVDataToFile(csvFile);
    // Atualiza o gráfico no painel
    chartPanel.repaint();
  }

  public static void addToCSVData(String seriesName, int iteration, double averageTime) {
    csvData.add(new String[] { seriesName, Integer.toString(iteration), Double.toString(averageTime) });
  }

  // Write CSV data to a CSV file
  public static void writeCSVDataToFile(File csvFile) {
    try (FileWriter writer = new FileWriter(csvFile)) {
      // Write CSV data to file
      for (String[] row : csvData) {
        writer.append(String.join(",", row))
            .append("\n");
      }
      System.out.println("CSV data written to file successfully!");
    } catch (IOException e) {
      System.err.println("Error writing CSV data to file: " + e.getMessage());
    }
  }

  public static void saveGraph() {
    if (chart != null) {
      try {
        File imageFile = new File("./results/UCB1.png");

        ChartUtils.saveChartAsPNG(imageFile, chart, 600, 400);
        System.out.println("Chart saved as image successfully!");
      } catch (IOException e) {
        System.err.println("Error saving chart as image: " + e.getMessage());
      }
    }
  }

}