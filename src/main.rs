use warp::Filter;

#[tokio::main]
async fn main() {
    // Define the route: GET / returns "Hello, World!"
    let hello = warp::path::end().map(|| "Hello, World!");

    // Start the web server on port 3030
    warp::serve(hello).run(([0, 0, 0, 0], 3030)).await;
}
