#shader vertex
#version 330 core
layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aNormal;
//layout(location = 2) in vec2 aTex;

out vec3 worldPos;
out vec3 Normal;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	worldPos = vec3(model * vec4(aPos, 1.0));
	Normal = mat3(transpose(inverse(model))) * aNormal;
	gl_Position = projection * view * vec4(worldPos, 1.0f);
	// gl_Position = projection * view * vec4(aPos, 1.0f);
}


#shader fragment
#version 330 core
out vec4 FragColor;
in vec3 worldPos;
in vec3 Normal;

uniform vec3 lightPos;
uniform vec3 camPos;

void main()
{
	vec3 baseColor = vec3(1.0);
	vec3 lightColor = vec3(1.0);

	vec3 N = normalize(Normal);
	vec3 V = normalize(camPos - worldPos);
	vec3 L = normalize(lightPos - worldPos);
	vec3 H = normalize(V + L);

	float NdotL = max(dot(N, L), 0.0);
	float NdotH = max(dot(N, H), 0.0);

	vec3 ambient = 0.2 * lightColor;
	vec3 diffuse = lightColor * NdotL;
	vec3 specular = 0.5 * lightColor * pow(NdotH, 8);

	vec3 color = (ambient + diffuse + specular) * baseColor;
	FragColor = vec4(color, 1.0f);
}