#version 330

// Input vertex attributes (from vertex shader)
in vec2  fragTexCoord;
in vec4  fragColor;

// Input uniform values
uniform sampler2D texture0;
uniform sampler2D texture1;
uniform vec4 colDiffuse;

uniform float hasColor;
uniform float outlineSize;
uniform vec2 textureSize;
uniform vec4 chosenProv;
uniform int mapmode;
uniform float zoom;

// Output fragment color
out vec4 finalColor;

// NOTE: Add here your custom variables

void main() {
	vec2 scale = vec2(0.0);
	scale.x = 1/(textureSize.x*2);
	scale.y = 1/(textureSize.y*2);

	vec4 texelColor  = texture(texture0, fragTexCoord);

	vec4 tcUp    = texture(texture0, vec2(fragTexCoord.x, fragTexCoord.y + scale.y));
	vec4 tcDown  = texture(texture0, vec2(fragTexCoord.x, fragTexCoord.y - scale.y));
	vec4 tcLeft  = texture(texture0, vec2(fragTexCoord.x + scale.x, fragTexCoord.y));
	vec4 tcRight = texture(texture0, vec2(fragTexCoord.x - scale.x, fragTexCoord.y));

	vec4 blur = vec4(
		(texelColor.x + tcUp.x + tcDown.x + tcLeft.x + tcRight.x) / 5,
		(texelColor.y + tcUp.y + tcDown.y + tcLeft.y + tcRight.y) / 5,
		(texelColor.z + tcUp.z + tcDown.z + tcLeft.z + tcRight.z) / 5,
		(texelColor.w + tcUp.w + tcDown.w + tcLeft.w + tcRight.w) / 5
	);

	// Convert texel color to grayscale using NTSC conversion weights
	vec4 texelColor2 = texture(texture1, fragTexCoord);
	float gray = dot(texelColor.rgb, vec3(0.299, 0.587, 0.114));

	if (texelColor != tcUp || texelColor != tcDown || texelColor != tcLeft || texelColor != tcRight) {
		if (texelColor == chosenProv) finalColor = vec4(1,0,0,1);
		else finalColor = mix(vec4(1,1,1,1), texelColor, 4);
	} else {
		finalColor = texelColor2;
	}
	//finalColor = (texelColor + texelColor2) / 2;
}