# Realistic-3D-Light-Shadow-Simulation
A real-time 3D lighting and shadow simulation using Processing (P3D), featuring interactive light control, reflections, shadow projection, and object customization.
🚀 Features
💡 Real-Time Point Light control (position + color)

🕹️ Keyboard & GUI Control with ControlP5 and PeasyCam

🌑 Soft Shadow Projection via custom shadow matrix

🔁 Reflection Rendering below the object

🔷 Choose between Sphere, Box, or Torus

🌈 Custom Light Color (RGB sliders)

📏 Ray Visualization from light to object

🎮 Controls
🧭 Move Light Source

Key	Function
W / S	Move light Up / Down
A / D	Move light Left / Right
↑ / ↓	Move light Forward / Back
← / →	Move light Left / Right
🔧 Switch Shape

Key	Shape
1	Sphere (default)
2	Box
3	Torus
🖱️ GUI Panel (Left side)
🎚️ Sliders for light position (lx, ly, lz)

🎚️ Sliders for light color (r, g, b)

✅ Toggle Show Light Ray

📦 Drop-down menu for object shape

🛠️ Requirements
Processing 3.5+

ControlP5 Library

PeasyCam Library

📦 Install Libraries
Go to Sketch > Import Library > Add Library...

Search for:

ControlP5

PeasyCam

Click Install

🧠 Code Highlights
drawScene() – Core rendering logic (ground, shape, shadow, reflection, light ray)

applyShadowMatrix() – Projects a soft planar shadow using a custom matrix

drawReflection() – Renders flipped geometry with alpha transparency

updateLightFromKeyboard() – Updates light source position in real-time via keyboard

📂 Project Structure
plaintext
Copy
Edit
/sketch_folder/
│
├── realistic_3d_light_simulation.pde    # Main sketch file
├── controlP5.jar                        # ControlP5 library (optional if installed)
├── peasycam.jar                         # PeasyCam library (optional if installed)
└── preview.gif                          # (optional) preview animation/image
📘 License
This project is open-source and available under the MIT License.

🙌 Author
Created by Ni TAKS (2025)
🎓 Suitable for educational projects or computer graphics simulations.
