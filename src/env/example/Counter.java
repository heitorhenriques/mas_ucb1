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
	DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm:ss");

	Double avgTime = 0.0;
	Double totalTime = 0.0;
	int iterations = 0;
	String csvName;
	int performOnLoop = 0;
	boolean isEven = true;

	private double min = 1;
	private double max = 5000;
	String DISTRIBUTOR_IP;

	void init(String csvname, int performOnLoopInt) {
		String myEnvVar = System.getenv("OBSERVATION_WINDOW");
		System.out.println(myEnvVar);
		//DISTRIBUTOR_IP = System.getenv("DISTRIBUTOR_IP");
		DISTRIBUTOR_IP = "192.168.3.7";
		defineObsProperty("observation_window",5000);
		Graph.startGraph(csvname);
		this.csvName = csvname;
		this.performOnLoop = performOnLoopInt;
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
				.uri(URI.create("http://"+DISTRIBUTOR_IP+":3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		while(response.body().equals("NOT FOUND")){System.out.println("I'm not receive a response from distributor");response = client.send(request, HttpResponse.BodyHandlers.ofString());}
		String[] parts = response.body().split(",");
		String res1 = parts[0];
		Double res2 = Double.parseDouble(parts[1]);

		totalTime = totalTime + res2;
		iterations++;
		avgTime = totalTime / iterations;

		avg_time.set(res2);
		action.set(res1);
		//Graph.updateData(avgTime, res2, csvName);

	}

	void addToList() throws IOException, InterruptedException {
		// if (iterations % 2 == 0) {
			HttpClient client = HttpClient.newHttpClient();

			log("Adding new element to the list...", "");

			String charToAdd;

			if (isEven) {
				charToAdd = "2";
				isEven = false;

			} else {
				charToAdd = "1";
				isEven = true;
			}

			HttpClient addClient = HttpClient.newHttpClient();
			HttpRequest addRequest = HttpRequest.newBuilder()
					.uri(URI.create("http://"+DISTRIBUTOR_IP+":8080/add"))
					.POST(HttpRequest.BodyPublishers.ofString(charToAdd))
					.build();

			HttpResponse<String> responseAdd = client.send(addRequest,
					HttpResponse.BodyHandlers.ofString());
		// }
	}

	void removeFromList() throws IOException, InterruptedException {
		// if (iterations % 2 == 0) {
			HttpClient client = HttpClient.newHttpClient();
			
			String charToRemove = String.valueOf(iterations);
			
			log("Removing element " + charToRemove + " from the list...", "");

			HttpClient removeClient = HttpClient.newHttpClient();
			HttpRequest removeRequest = HttpRequest.newBuilder()
					.uri(URI.create("http://"+DISTRIBUTOR_IP+":8080/remove"))
					.POST(HttpRequest.BodyPublishers.ofString(charToRemove))
					.build();

			HttpResponse<String> responseRemove = client.send(removeRequest,
					HttpResponse.BodyHandlers.ofString());
		// }
	}

	@OPERATION
	void ignoreAvgTime()
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://"+DISTRIBUTOR_IP+":3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		while(response.body().equals("NOT FOUND")){System.out.println("I'm not receive a response from distributor");response = client.send(request, HttpResponse.BodyHandlers.ofString());}
		if(!response.body().equals("NOT FOUND")){
			log("Ignoring result: " + response.body().split(",")[1], response.body().split(",")[0]);
		}
		switch (performOnLoop) {
			case 1:
				addToList();
				break;
			case 2:
				removeFromList();
				break;

			default:
				break;
		}
	}

	@OPERATION
	public void sendOperation(String composition) throws IOException, InterruptedException {
		Graph.saveGraph();

		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://"+DISTRIBUTOR_IP+":3500/ucb/composition"))
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
