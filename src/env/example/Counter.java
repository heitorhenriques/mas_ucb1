// CArtAgO artifact code for project teste

package example;

import cartago.*;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Counter extends Artifact {
	DateTimeFormatter TIME_FORMATTER = 	DateTimeFormatter.ofPattern("HH:mm:ss");

	Double avgTime = 0.0;
	Double totalTime = 0.0;
	int iterations = 0;
	String csvName;

	private double min = 360;
	private double max = 605;

	void init(String csvname) {
		Graph.startGraph();
		this.csvName = csvname;
	}

	@OPERATION
	public void log(String message, String action) {
		String currentTime = LocalTime.now().format(TIME_FORMATTER);
		if(action != "") {
			System.out.println("[" + currentTime + " - Action " + action +"] " + message);
		} else {
			System.out.println("[" + currentTime + "] " + message);
		}
    }

	@OPERATION
	void inc() {
		ObsProperty prop = getObsProperty("count");
		prop.updateValue(prop.intValue() + 1);
		signal("tick");
	}

	@OPERATION
	void incGet(int inc, OpFeedbackParam<Integer> newValueArg) {
		ObsProperty prop = getObsProperty("count");
		int newValue = prop.intValue() + inc;
		prop.updateValue(newValue);
		newValueArg.set(newValue);
	}

	@OPERATION
	void getAvgTime(OpFeedbackParam<String> action, OpFeedbackParam<Double> avg_time)
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.103:3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String[] parts = response.body().split(",");
		String res1 = parts[0];
		Double res2 = Double.parseDouble(parts[1]);

		// System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		// System.out.println("Resultado: " + res2);

		totalTime = totalTime + res2;
		iterations++;
		avgTime = totalTime / iterations;

		avg_time.set(res2);
		action.set(res1);
		Graph.updateData(avgTime, res2, csvName);
	}

	@OPERATION
	void ignoreAvgTime()
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.103:3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		
		// System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		// System.out.println("IGNORANDO RESULTADOOOOO" + response.body());

		return;
	}

	@OPERATION
	public void sendOperation(String composition) throws IOException, InterruptedException {
		Graph.saveGraph();

		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.103:3500/ucb/composition"))
				.POST(HttpRequest.BodyPublishers.ofString(composition))
				.build();

		HttpResponse<String> response = client.send(request,
				HttpResponse.BodyHandlers.ofString());
	}

	@OPERATION
	void confidenceLevel(double reward, double times_chosen, double iterations,
			OpFeedbackParam<Double> confidence_level) {

		double result = (reward / times_chosen) + Math.sqrt((2 * Math.log(iterations)) / (1 + times_chosen));
		confidence_level.set(result);
	}

	@OPERATION
	void getReward(double avg_time,
			OpFeedbackParam<Double> reward) {

		double result = (max - avg_time) / (max - min);
		reward.set(result);
	}

}
