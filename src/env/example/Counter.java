// CArtAgO artifact code for project teste

package example;

import cartago.*;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class Counter extends Artifact {
	Double avgTime = 0.0;
	Double totalTime = 0.0;
	int iterations = 0;

	void init(int initialValue) {
		defineObsProperty("count", initialValue);
		Graph.startGraph();
	}

	@OPERATION
	void inc() {
		ObsProperty prop = getObsProperty("count");
		prop.updateValue(prop.intValue() + 1);
		signal("tick");
	}

	@OPERATION
	void inc_get(int inc, OpFeedbackParam<Integer> newValueArg) {
		ObsProperty prop = getObsProperty("count");
		int newValue = prop.intValue() + inc;
		prop.updateValue(newValue);
		newValueArg.set(newValue);
	}

	@OPERATION
	void get_avg_time(OpFeedbackParam<String> action, OpFeedbackParam<Double> avg_time)
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://localhost:3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String[] parts = response.body().split(",");
		String res1 = parts[0];
		Double res2 = Double.parseDouble(parts[1]);

		totalTime = totalTime + res2;
		iterations++;
		avgTime = totalTime / iterations;

		avg_time.set(res2);
		action.set(res1);
		Graph.updateData(avgTime, res2);
	}

	@OPERATION
	void send_operation(String composition) throws IOException, InterruptedException {
		Graph.saveGraph();

		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://localhost:3500/ucb/composition"))
				.POST(HttpRequest.BodyPublishers.ofString(composition))
				.build();

		HttpResponse<String> response = client.send(request,
				HttpResponse.BodyHandlers.ofString());
	}

	@OPERATION
	void confidence_level(double reward, double times_chosen, double iterations,
			OpFeedbackParam<Double> confidence_level) {
		double result = (reward / times_chosen) + Math.sqrt((2 * Math.log(iterations)) / (1 + times_chosen));
		confidence_level.set(result);
	}

}
