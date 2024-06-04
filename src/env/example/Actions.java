// CArtAgO artifact code for project teste

package example;

import cartago.*;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class Actions extends Artifact {

	void init() {
		defineObsProperty("vez",0);
	}

	@OPERATION void inc(){
		ObsProperty prop = getObsProperty("vez");
		prop.updateValue(prop.intValue()+1);
	}

	@OPERATION
	void get_avg_time(OpFeedbackParam<String> action, OpFeedbackParam<Double> avg_time)
			throws IOException, InterruptedException {
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.103:3500/ucb/perception-data"))
				.build();

		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String[] parts = response.body().split(",");
		String res1 = parts[0];
		Double res2 = Double.parseDouble(parts[1]);

		avg_time.set(res2);
		action.set(res1);
	}

	@OPERATION
	public void send_operation(String composition) throws IOException, InterruptedException {

		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("http://192.168.0.103:3500/ucb/composition"))
				.POST(HttpRequest.BodyPublishers.ofString(composition))
				.build();

		HttpResponse<String> response = client.send(request,
				HttpResponse.BodyHandlers.ofString());
	}

}
