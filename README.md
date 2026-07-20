```mermaid
flowchart TD
    A["💻 Developer Laptop<br/>(Java/Spring Boot)"]
    B["🐙 GitHub Repo<br/>Source Code Storage"]
    C["⚙️ Jenkins CI<br/>1. Pull Code<br/>2. Maven Build<br/>3. Run Tests<br/>4. Build Docker Img"]
    D["🐳 Docker Image<br/>bookstore-api:v1"]
    E["📦 Docker Hub / Harbor<br/>Image Registry"]
    F["🖥️ Linux Server<br/>docker run -d<br/>-p 8080:8080<br/>bookstore-api:v1"]
    G["🧑‍🤝‍🧑 End Users<br/>http://server:8080"]

    A ==>|"git push"| B
    B ==>|"Webhook Trigger"| C
    C ==>|"docker build"| D
    D ==>|"docker push (optional)"| E
    E ==>|"pull latest image"| F
    F ==>|"HTTP Request"| G

    classDef dev fill:#f9c74f,stroke:#7f5a00,stroke-width:3px,color:#000,font-weight:bold
    classDef github fill:#24292e,stroke:#000,stroke-width:3px,color:#fff,font-weight:bold
    classDef jenkins
