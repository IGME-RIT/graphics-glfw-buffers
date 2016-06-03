/*
Title: Buffers
File Name: VertexShader.glsl
Copyright © 2015
Original authors: Joshua Alway
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Description:
This program serves to demonstrate rendering with buffers, using two Texture Buffers 
(which are essentially 1d Textures or arrays of data) for Vertex and Index data. 
The mesh drawn is loaded from a .obj export from Blender (there are comments in 
the .obj file too!). The buffers are passed in as uniform samplerBuffers, and 
are accessed via texelFetch (VertexID determines which index in the index buffer to use, 
and that value is then used to texelFetch from the vertex buffer).
*/

#version 440 core // Identifies the version of the shader, this line must be on a separate line from the rest of the shader code

out vec4 color; // Our vec4 color variable containing r, g, b, a

uniform mat4 MVP; // Our uniform Model-View-Projection matrix to modify our position values

// this has a "samplerBuffer" type sampler; this limits us to texelFetch calls on it.
layout(binding = 1) uniform samplerBuffer positionBufferTexture;

// another samplerBuffer type; however, this contains signed ints, hence isamplerBuffer
layout(binding = 2) uniform isamplerBuffer triangleBufferTexture;

void main(void)
{
    int i = gl_VertexID;

    // Get the index of the position we will be using for this vertex.
    // Essentially means: Index = triangleBuffer[i]
    int Index = texelFetch( triangleBufferTexture, i ).r;

    // Then use that index to get a position.
    // Essentially means: vertexPosition = positionBuffer[Index]
    vec3 vertexPosition = texelFetch( positionBufferTexture, (Index) ).rgb;


    vec4 ClipSpace = MVP * vec4( vertexPosition.xyz, 1.0 );

    // Use the indicies to give it a bit of color to show off the general shape of things.
    color = vec4(float(Index) * .0075, 1.0, 1.0, 1.0);

    gl_Position = ClipSpace;
}													 

