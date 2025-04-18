## Gaia Domain

This project brings you the complete ecosystem of Gaia domain.

## Getting started with `gaia-domain`

Follow these steps to establish your domain and allow Gaia nodes to join your network.

### Prerequisites

- **Docker:** Ensure you have Docker and Docker Compose installed on your system. ([Install Docker](https://docs.docker.com/engine/install/))
- **Domain Name:** You'll need a registered domain name (e.g., `yourdomain.ai`).
- **DNS Management Access:** Access to your domain name provider's DNS settings.
- **AWS Credentials (Optional):** Required if you intend to use the logging features with AWS S3.

### ⚙️ Installation

1.  **Clone the Repository:**

    ```shell
    git clone [https://github.com/GaiaNet-AI/gaia-domain.git](https://github.com/GaiaNet-AI/gaia-domain.git)
    cd gaia-domain
    ```

2.  **Build the Docker Containers:**

    Choose your preferred database backend:

    - **Using SQLite (Easy Setup):**

      ```shell
      docker compose build
      ```

    - **Using MySQL (Scalable and Robust):**

      ```shell
      docker compose -f compose.mysql.yml build
      ```

3.  **Configuration: Setting Up Your Domain:**

    Adapt the configuration files to reflect your chosen domain name (`yourdomain.ai`). Replace all instances of `yourdomain.ai` with your actual domain in the following files:

    - `frps/conf/frps.toml`
    - `nginx/conf.d/domain.conf`
    - `nginx/conf.d/hub.conf`
    - `nginx/conf.d/grpc.conf` (specifically the `server_name`)

    **DNS Records:** At your domain provider, configure the following DNS A records to point to the **IP address of your server** hosting the Gaia Domain:

    - `yourdomain.ai`
    - `*.yourdomain.ai`

    This ensures that both your root domain and any subdomains can be resolved to your server.

4.  **Initialize the Database:**

    Run the appropriate script to set up the database schema:

    - **Using SQLite:**

      ```shell
      sh init.sh
      ```

    - **Using MySQL:**

      ```shell
      sh init-mysql.sh
      ```

5.  **Environment Variables (AWS Credentials):**

    If you want to enable logging to AWS S3, you need to provide your AWS access keys. You can do this in two ways:

    - **Export as Environment Variables:**

      ```shell
      export AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
      export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
      ```

    - **Create a `.env` File:**

      Create a file named `.env` in the root of the repository with the following content:

      ```.env
      AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
      ```

    Docker Compose will automatically load these variables.

6.  **Launch Your Gaia Domain:**

    Start the Docker containers to bring your domain online:

    - **Using SQLite:**

      ```shell
      docker compose up -d
      ```

    - **Using MySQL:**

      ```shell
      docker compose -f compose.mysql.yml up -d
      ```

7.  **(Optional) Redis Warning Fix:**

    If you encounter a warning in the Redis container related to memory overcommit, you can resolve it by running the following commands on your host machine:

    ```bash
    echo 'vm.overcommit_memory = 1' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    ```

    **Note:** This requires `sudo` privileges.

That's all!

## Connecting Gaia Nodes to Your Domain

For a Gaia node to join your newly created domain, a configuration change is required on the node's side **before** running the `gaianet init` command on the node.

Edit the `config.json` file on the Gaia node:

- Change the `domain` field to your **root domain name** (e.g., `"domain": "yourdomain.ai"`).
- Modify the domain in the `server_health_url` and `server_info_url` fields to point to your hub: `"server_health_url": "http://hub.domain.yourdomain.ai/node-health"` and `"server_info_url": "http://hub.domain.yourdomain.ai/node-info"`.

## 🤝 Contributing to Gaia Domain

Gaia Domain is an open-source project, and contributions from the community are highly valued! We believe in collaborative development to build a robust and innovative platform.

**How You Can Contribute:**

- **Reporting Issues:** If you encounter bugs, have feature requests, or find areas for improvement, please open a detailed issue on [GitHub Issues](https://github.com/GaiaNet-AI/gaia-domain/issues).
- **Submitting Pull Requests:** We welcome code contributions! If you've implemented a bug fix or a new feature, submit a pull request following our [Contribution Guidelines](https://github.com/Gaianet-AI/gaianet-domain/blob/main/CONTRIBUTING.md). Please ensure your code adheres to the project's style and includes relevant tests.
- **Documentation:** Help us improve [the documentation](https://docs.gaianet.ai/intro) by clarifying existing sections, adding new guides, or translating the documentation into other languages.
- **Testing:** Contribute by writing new unit, integration, or end-to-end tests to ensure the stability and reliability of the project.
- **Community Support:** Assist other builders by answering questions on GitHub issues or our [Telegram builders Community](https://t.me/+a0bJInD5lsYxNDJl).

Please take a look at our [Code of Conduct](https://github.com/Gaianet-AI/gaianet-domain/blob/main/CODE_OF_CONDUCT.md) to ensure a positive and inclusive environment for everyone.

## 📜 License

This project is licensed under the [GNU General Public License v3.0](https://github.com/GaiaNet-AI/gaia-domain/blob/main/LICENSE)

## Acknowledgements

We'd like to thank the open-source community for their invaluable tools and libraries that make this project possible.
