defmodule HomeworkAPITests do
    # Import helpers
    use Hound.Helpers
    use ExUnit.Case
    use HTTPoison.Base

    # Confirm we get expected user back from call
    test "GET users happy path" do
        get_url = "https://reqres.in/api/users/2"
        get_response = HTTPoison.get! get_url
        assert get_response.status_code == 200
        assert get_response.body() =~ "janet.weaver@reqres.in"
    end

    # Confirm delayed GET call returns data
    test "GET users delayed response" do
        get_url = "https://reqres.in/api/users?delay=3"
        get_response = HTTPoison.get! get_url
        assert get_response.status_code == 200
        assert get_response.body() =~ "janet.weaver@reqres.in"
    end

    # Confirm we get expected data back after POST of new user, and get expected 201
    test "POST new user happy path" do
        post_url = "https://reqres.in/api/users"
        post_response = HTTPoison.post! post_url, "{\"body\": {\"email\": \"test@divvy.test\"}}", [{"Content-Type", "application/json"}]
        assert post_response.status_code == 201
        assert post_response.body() =~ "test@divvy.test"
    end

    # Confirm login POST unsuccessful without password
    test "POST login said path missing password" do
        post_url = "https://reqres.in/api/login"
        post_response = HTTPoison.post! post_url, "{\"body\":{\"email\":\"eve.holt@reqres.in\"}}", [{"Content-Type", "application/json"}]
        assert post_response.status_code == 400
        assert post_response.body() =~ "Missing email or username"
    end

    # Confirm login POST unsuccessful without email
    test "POST login sad path missing email" do
        post_url = "https://reqres.in/api/login"
        post_response = HTTPoison.post! post_url, "{\"body\":{\"password\": \"cityslicka\"}}", [{"Content-Type", "application/json"}]
        assert post_response.status_code == 400
        assert post_response.body() =~ "Missing email or username"
    end

    # Confirm we can PUT user
    test "PUT user happy path" do
        put_url = "https://reqres.in/api/users/2"
        put_response = HTTPoison.put! put_url, "{\"body\": {\"name\": \"PUTtest\", \"job\": \"testJob\"}}", [{"Content-Type", "application/json"}]
        assert put_response.status_code == 200
        assert put_response.body() =~ "updatedAt"
    end

    # Confirm we can PATCH user
    test "PATCH user happy path" do
        patch_url = "https://reqres.in/api/users/2"
        patch_response = HTTPoison.patch! patch_url, "{\"body\": {\"name\": \"PATCHtest\", \"job\": \"testJob\"}}", [{"Content-Type", "application/json"}]
        assert patch_response.status_code == 200
        assert patch_response.body() =~ "PATCHtest"
    end

    # Confirm expeted 204 is returned from DELETE endpoint, and that no response body is returned
    test "DELETE user happy path" do
        delete_url = "https://reqres.in/api/users/2"
        delete_response = HTTPoison.delete! delete_url
        assert delete_response.status_code == 204
        assert delete_response.body() == ""
    end
end
