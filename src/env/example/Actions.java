// CArtAgO artifact code for project teste

package example;

import cartago.*;
import jason.stdlib.signal;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Actions extends Artifact {
	DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm:ss");
	String csvName;
	Double avgTime = 0.0;
	Double totalTime = 0.0;
	int iterations = 0;
	int numberOfAgents = 2;
	boolean addLoopEnabled = false;
	boolean addEven = true;

	void init(String csvname, boolean addLoop) {
		defineObsProperty("turn",0);
		Graph.startGraph(csvname);
		this.csvName = csvname;
		this.addLoopEnabled = addLoop;
	}

	@OPERATION
	public void log(String message, String action) {
		String currentTime = LocalTime.now().format(TIME_FORMATTER);
		if (action != "") {
			System.out.println("(" + iterations + ") [" + currentTime + " - Action " + action + "] " + message);
		} else {
			System.out.println("(" + iterations + ") [" + currentTime + "] " + message);
		}
	}

	@OPERATION void inc(){
		ObsProperty prop = getObsProperty("turn");
		prop.updateValue(((prop.intValue()+1)%numberOfAgents));
	}

	@OPERATION
	void ignoreAvgTime()
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.100:3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

		log("Ignoring result: " + response.body().split(",")[1], response.body().split(",")[0]);

		return;
	}

	@OPERATION
	void get_avg_time(OpFeedbackParam<String> action, OpFeedbackParam<Double> avg_time)
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.100:3500/ucb/perception-data"))
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
		Graph.updateData(avgTime, res2, csvName);

		if (addLoopEnabled && iterations % 2 == 0) {
			log("Adding new element to the list...", "");

			String charToAdd;

			if (addEven) {
				charToAdd = "2";
				addEven = false;

			} else {
				charToAdd = "1";
				addEven = true;
			}

			HttpClient addClient = HttpClient.newHttpClient();
			HttpRequest addRequest = HttpRequest.newBuilder()
					.uri(URI.create("http://192.168.0.100:8080/add"))
					.POST(HttpRequest.BodyPublishers.ofString(charToAdd))
					.build();

			HttpResponse<String> responseAdd = client.send(addRequest,
					HttpResponse.BodyHandlers.ofString());
		}
	}

	@OPERATION
	public void send_operation(String composition) throws IOException, InterruptedException {

		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.100:3500/ucb/composition"))
				.POST(HttpRequest.BodyPublishers.ofString(composition))
				.build();

		HttpResponse<String> response = client.send(request,
				HttpResponse.BodyHandlers.ofString());
	}

}
