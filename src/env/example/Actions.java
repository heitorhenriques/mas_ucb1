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

public class Actions extends Artifact {
	DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm:ss");
	String csvName;
	Double avgTime = 0.0;
	Double totalTime = 0.0;
	int iterations = 0;
	int numberOfAgents = 2;
	int performOnLoop;
	boolean isEven = true;
	String DISTRIBUTOR_IP;

	void init(String csvname, int performOnLoopInt) {
		// String myEnvVar = System.getenv("OBSERVATION_WINDOW");
		String myEnvVar = "11000";
		// DISTRIBUTOR_IP = System.getenv("DISTRIBUTOR_IP");
		DISTRIBUTOR_IP = "192.168.0.102";
		defineObsProperty("observation_window",Integer.parseInt(myEnvVar));
		defineObsProperty("turn",0);
		defineObsProperty("mutex",0);
		Graph.startGraph(csvname);
		this.csvName = csvname;
		this.performOnLoop = performOnLoopInt;

		if(performOnLoop == 0) {
			log("Running with constant list.");
		} else if (performOnLoop == 1) {
			log("Running increasing the list.");
		} else if (performOnLoop == 2) {
			log("Running decreasing the list.");
		}
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

	@OPERATION void inc_mutex(){
		ObsProperty prop = getObsProperty("mutex");
		prop.updateValue(((prop.intValue()+1)%2));
	}

	@OPERATION
	void ignoreAvgTime()
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://"+DISTRIBUTOR_IP+":3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		while(response.body().equals("NOT FOUND")){response = client.send(request, HttpResponse.BodyHandlers.ofString());}
		log("Ignoring result: " + response.body().split(",")[1], response.body().split(",")[0]);

		return;
	}

	@OPERATION
	void get_avg_time(OpFeedbackParam<String> action, OpFeedbackParam<Double> avg_time)
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://"+DISTRIBUTOR_IP+":3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		while(response.body().equals("NOT FOUND")){response = client.send(request, HttpResponse.BodyHandlers.ofString());}
		String[] parts = response.body().split(",");
		String res1 = parts[0];
		Double res2 = Double.parseDouble(parts[1]);

		totalTime = totalTime + res2;
		iterations++;
		avgTime = totalTime / iterations;

		avg_time.set(res2);
		action.set(res1);
		Graph.updateData(avgTime, res2, csvName);

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

			// if (isEven) {
			// 	charToRemove = "2";
			// 	isEven = false;

			// } else {
			// 	charToRemove = "1";
			// 	isEven = true;
			// }

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
	public void send_operation(String composition) throws IOException, InterruptedException {

		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://"+DISTRIBUTOR_IP+":3500/ucb/composition"))
				.POST(HttpRequest.BodyPublishers.ofString(composition))
				.build();

		HttpResponse<String> response = client.send(request,
				HttpResponse.BodyHandlers.ofString());
	}

}
