package example;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import java.util.List;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;

public class Graph extends JFrame {

  private static final long serialVersionUID = 1L;
  private static XYSeries seriesTotal;
  private XYSeriesCollection dataset;
  private JFreeChart chart;
  private static ChartPanel chartPanel;

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

  // Cria o gráfico
  public Graph(String title, List<Double> avgTimes) {
    super(title);

    // Inicia as séries e o dataset
    seriesTotal = new XYSeries("Average Time");
    dataset = new XYSeriesCollection(seriesTotal);

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

  public static void updateData(Double newValue) {
    // Adiciona o novo valor à série
    seriesTotal.add(seriesTotal.getItemCount() + 1, newValue);

    // Atualiza o gráfico no painel
    chartPanel.repaint();
  }

}