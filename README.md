# RTL to GDSII Flow using SKY130, Yosys, OpenROAD & Magic

## 📑 Table of Contents

- [🛠️ Prerequisites](#️-prerequisites)
- [📥 Installing the IIC Docker Environment](#-installing-the-iic-docker-environment)
- [📂 Accessing Your Project Files (Windows)](#-accessing-your-project-files-windows)
- [STEP 1 — Project Setup & Environment Preparation](#step-1--project-setup--environment-preparation)
- [STEP 2 — RTL Synthesis using Yosys](#step-2--rtl-synthesis-using-yosys)
- [STEP 3 — OpenROAD Design Initialization & Linking](#step-3--openroad-design-initialization--linking)
- [STEP 4 — Floorplanning](#step-4--floorplanning)
- [STEP 5 — Routing Tracks & IO Pin Placement](#step-5--routing-tracks--io-pin-placement)
- [STEP 6 — Global Placement & Detailed Placement](#step-6--global-placement--detailed-placement)
- [STEP 7 — Global Routing](#step-7--global-routing)
- [STEP 8 — Detailed Routing (Final Routing)](#step-8--detailed-routing-final-routing)
- [STEP 9 — Magic Layout Verification, Extraction & GDS Generation](#step-9--magic-layout-verification-extraction--gds-generation)
- [STEP 10 — Final GDS Verification using KLayout](#step-10--final-gds-verification-using-klayout)

---

# 🛠️ Prerequisites

This project is implemented using the **IIC Open-Source EDA Docker Environment**, which provides a pre-configured Linux environment containing all the required ASIC design tools such as **OpenROAD, Yosys, Magic VLSI, KLayout, Netgen**, and the **SKY130 PDK**.

> **Note:** This repository assumes that all commands are executed inside the IIC Docker environment.

---

# 📥 Installing the IIC Docker Environment

1. Install **Docker Desktop** from the official website:

   https://www.docker.com/products/docker-desktop/

2. Download the **IIC-OSIC-TOOLS** installer package (the image and `.bat` file are provided in this repository).

3. Double-click the provided **`.bat`** file.

4. The installation process may take approximately **15–20 minutes**, depending on your internet speed and system performance.

5. Once the installation is complete, a **Linux terminal** will automatically open. This is the environment where all the commands in this project are executed.

---

# 📂 Accessing Your Project Files (Windows)

If you are using **Windows**, the files created inside the Docker/Linux environment are also available on your Windows file system.

Navigate to:

```text
C:\
 └── Users
      └── <Your_Username>
           └── eda
                └── foss
                     └── designs
                          └── <Your_Project_Folder>
```

For example, on my system:

```text
C:\Users\ASUS\eda\foss\designs\
```

Inside the `designs` folder, you will find all the project directories and files created during the RTL-to-GDS flow, including:

- RTL source files
- Synthesis outputs
- OpenROAD databases (`.odb`)
- DEF files
- Magic layout files (`.mag`)
- SPICE netlists
- GDSII layouts
- Reports and other generated files

This makes it convenient to edit, copy, back up, or upload your project files directly from Windows while continuing to execute the ASIC flow inside the Linux Docker environment.

---

## STEP 1 — Project Setup & Environment Preparation

### Objective
Create a clean project directory, organize all design files, and verify that the required tools and PDK are available before starting synthesis.

### Folder Structure

Create a new project folder. Example:

```
/foss/designs/
└── MUX_2x1_RTL_to_GDS/
```

Go into it:

```bash
cd /foss/designs/MUX_2x1_RTL_to_GDS
```

### Files Required

At minimum:

```
Mux_2x1.sv
```

or

```
Mux_2x1.v
```

Optional:

```
constraints.sdc
sta.tcl
```

### Verify Current Directory

```bash
pwd
```

Expected output:

```
/foss/designs/MUX_2x1_RTL_to_GDS
```

### Verify Design File Exists

```bash
ls
```

Expected:

```
Mux_2x1.sv
```

# 2x1 Multiplexer Files

## SystemVerilog Source (`Mux_2x1.sv`)

```systemverilog
module Mux_2x1 (
    input logic i0,
    input logic i1,
    input logic sel,
    output logic out
);

    assign out = (sel) ? i1 : i0;

endmodule
```

### Verify OpenROAD

```bash
openroad
```

Expected:

```
OpenROAD 26Q2-xxx
```

Exit:

```bash
exit
```

### Verify Yosys

```bash
yosys
```

Expected:

```
yosys>
```

Exit:

```bash
exit
```

### Verify Magic

```bash
magic
```

Expected: Magic GUI opens.

Exit:

```bash
quit
```

### Verify KLayout

```bash
klayout
```

Expected: GUI opens.

### Verify SKY130 PDK

Check the PDK location:

```bash
echo $PDKPATH
```

Expected:

```
/...
```

For our setup, it was:

```
/foss/pdks/sky130A
```

### Verify Standard Cell Library

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd
```

Expected folders:

```
cdl
gds
lef
lib
mag
maglef
spice
techlef
verilog
```

### Verify Technology LEF

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/techlef
```

Expected:

```
sky130_fd_sc_hd__nom.tlef
```

### Verify Standard Cell LEF

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/lef
```

Expected:

```
sky130_fd_sc_hd.lef
```

### Verify Liberty Files

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/lib
```

Expected: Several `.lib` timing files.

### Verify Standard Cell Verilog Models

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/verilog
```

Expected:

```
primitives.v
sky130_fd_sc_hd.v
```

### Verify Standard Cell GDS

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/gds
```

Expected:

```
sky130_fd_sc_hd.gds
```

### Verify Standard Cell Magic Layouts

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/mag | head
```

Expected: Many `.mag` files.

### Verify Track Information

```bash
find /foss/pdks -name tracks.info
```

For our setup we used:

```
/foss/pdks/ciel/sky130/versions/.../sky130A/libs.tech/librelane/sky130_fd_sc_hd/tracks.info
```

### Files after Step 1

Your project should contain something like:

```
Mux_2x1.sv
constraints.sdc
sta.tcl
```

No synthesis outputs yet.

### Common Problems

**1. `$PDKPATH` is empty**

Solution:

```bash
echo $PDKPATH
```

If empty, source your environment or set the variable according to your installation.

**2. `openroad: command not found`**

The OpenROAD environment is not loaded.

**3. `magic: command not found`**

Magic is not installed or not in your `PATH`.

**4. `sky130_fd_sc_hd.lef` not found**

Verify:

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/lef
```

### What You Should Understand Before Moving On

At the end of Step 1, you should know:

- Why we need the SKY130 PDK.
- What the LEF, Liberty, Verilog, GDS, and Magic libraries provide.
- Where your design files live.
- How to verify that all required tools are installed and accessible.

---

## STEP 2 — RTL Synthesis using Yosys

### Objective

Convert the RTL (SystemVerilog/Verilog) description into a technology-mapped gate-level netlist using the SKY130 standard cell library.

At the end of this step, your RTL design will be transformed into a netlist containing only SKY130 standard cells (such as `sky130_fd_sc_hd__mux2_1`, `sky130_fd_sc_hd__and2_0`, etc.), which OpenROAD can use for physical implementation.

### Theory

RTL written in Verilog/SystemVerilog is behavioral. Fabrication tools cannot manufacture behavioral descriptions.

Yosys performs the following tasks:

```
RTL (Mux_2x1.sv)
        │
        ▼
Parse Verilog/SystemVerilog
        │
        ▼
Elaborate Design
        │
        ▼
Logic Optimization
        │
        ▼
Technology Mapping
        │
        ▼
SKY130 Standard Cells
        │
        ▼
Mux_2x1_sky130.v
```

### Required Files

Your project folder should contain:

```
Mux_2x1.sv
```

PDK should contain:

```
$PDKPATH/libs.ref/sky130_fd_sc_hd/lib/
```

### Go to the Project Directory

```bash
cd /foss/designs/MUX_2x1_RTL_to_GDS
```

Verify:

```bash
pwd
```

Expected:

```
/foss/designs/MUX_2x1_RTL_to_GDS
```

### Launch Yosys

```bash
yosys
```

Expected:

```
yosys>
```

### Read the RTL

If using Verilog:

```
read_verilog Mux_2x1.sv
```

If using SystemVerilog features:

```
read_verilog -sv Mux_2x1.sv
```

### Verify the Module

```
hierarchy -check -top Mux_2x1
```

Purpose:

- Checks module hierarchy
- Detects missing modules
- Sets the top module

Expected output:

```
Top module: \Mux_2x1
```

### Generic Logic Synthesis

```
synth -top Mux_2x1
```

This performs:

- Process conversion
- Optimization
- Boolean simplification
- FSM optimization (if present)
- Resource sharing
- Logic cleanup

### Load the SKY130 Liberty File

For our setup we used:

```
read_liberty -lib \
$PDKPATH/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

If your library name differs, check it first:

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/lib
```

### Technology Mapping

Map generic logic to SKY130 cells.

```
dfflibmap \
-liberty \
$PDKPATH/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

Then:

```
abc \
-liberty \
$PDKPATH/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

### Clean the Design

```
clean
```

Removes:

- unused logic
- dangling wires
- unused cells

### Write the Gate-Level Netlist

```
write_verilog Mux_2x1_sky130.v
```

This file will be used by OpenROAD.

### Exit Yosys

```
exit
```

### Verify the Netlist

Back in Linux terminal:

```bash
ls
```

Expected:

```
Mux_2x1.sv
Mux_2x1_sky130.v
```

Open the synthesized netlist:

```bash
head -40 Mux_2x1_sky130.v
```

For our project it looked like:

```verilog
module Mux_2x1(i0, i1, sel, out);

...
sky130_fd_sc_hd__mux2_1 ...
...
endmodule
```

### Verify Standard Cells Used

Search the synthesized netlist:

```bash
grep sky130_fd_sc_hd Mux_2x1_sky130.v
```

Expected:

```
sky130_fd_sc_hd__mux2_1
```

or multiple SKY130 cells depending on your design.

### Verify Module Name

```bash
grep module Mux_2x1_sky130.v
```

Expected:

```
module Mux_2x1(
```

### ⚠ Important Note

Notice that the file name is:

```
Mux_2x1_sky130.v
```

but the module name inside is still:

```
module Mux_2x1
```

This is exactly what caused one of our OpenROAD issues. When linking the design later, you must use:

```
link_design Mux_2x1
```

not

```
link_design Mux_2x1_sky130
```

because OpenROAD links by module name, not by file name.

### Files Generated After Step 2

Your directory should now contain:

```
Mux_2x1.sv
Mux_2x1_sky130.v
```

### Common Errors & Fixes

**Error 1: RTL file not found**

```
ERROR: Can't open input file
```

Fix:

```bash
ls
```

Ensure the RTL file is in the current directory.

**Error 2: Module not found**

```
Module Mux_2x1 not found
```

Fix:

Verify:

```bash
grep module Mux_2x1.sv
```

**Error 3: ABC cannot map**

Usually caused by an incorrect Liberty path.

Verify:

```bash
ls $PDKPATH/libs.ref/sky130_fd_sc_hd/lib
```

**Error 4: Wrong top module**

Always execute:

```
hierarchy -check -top Mux_2x1
```

before synthesis.

**Error 5: OpenROAD later reports**

```
Mux_2x1 is not a verilog module
```

This usually happens because:

- You forgot to `read_verilog Mux_2x1_sky130.v` in OpenROAD.
- Or you tried:

```
link_design Mux_2x1_sky130
```

instead of:

```
link_design Mux_2x1
```

This was one of the issues we debugged during your project.

### Final Output of Step 2

```
RTL (Mux_2x1.sv)
        │
        ▼
Yosys Synthesis
        │
        ▼
Technology Mapping
        │
        ▼
Mux_2x1_sky130.v
```

```verilog
/* Generated by Yosys 0.64 (git sha1 6d2c445ae, g++ 13.3.0-6ubuntu2~24.04.1 -fPIC -O3) */

(* top =  1  *)
(* src = "Mux_2x1.sv:1.1-9.10" *)
module Mux_2x1(i0, i1, sel, out);
  (* src = "Mux_2x1.sv:2.17-2.19" *)
  input i0;
  wire i0;
  (* src = "Mux_2x1.sv:3.17-3.19" *)
  input i1;
  wire i1;
  (* src = "Mux_2x1.sv:4.17-4.20" *)
  input sel;
  wire sel;
  (* src = "Mux_2x1.sv:5.18-5.21" *)
  output out;
  wire out;
  (* src = "Mux_2x1.sv:2.17-2.19" *)
  wire _0_;
  (* src = "Mux_2x1.sv:3.17-3.19" *)
  wire _1_;
  (* src = "Mux_2x1.sv:5.18-5.21" *)
  wire _2_;
  (* src = "Mux_2x1.sv:4.17-4.20" *)
  wire _3_;
  sky130_fd_sc_hd__mux2_1 _4_ (
    .A0(_0_),
    .A1(_1_),
    .S(_3_),
    .X(_2_)
  );
  assign _0_ = i0;
  assign _1_ = i1;
  assign _3_ = sel;
  assign out = _2_;
endmodule
```

---

## STEP 3 — OpenROAD Design Initialization & Linking

### Objective

Initialize the OpenROAD environment by loading:

- Technology LEF (`.tlef`)
- Standard Cell LEF (`.lef`)
- Liberty timing library (`.lib`)
- Synthesized gate-level netlist (`Mux_2x1_sky130.v`)

Finally, link the design and save the first OpenROAD database.

### Theory

After synthesis, we only have a gate-level Verilog netlist.

OpenROAD cannot perform placement or routing unless it knows:

- 📏 Physical dimensions of every standard cell (LEF)
- ⏱️ Timing information (Liberty)
- 🧱 Technology rules (Tech LEF)
- 🔌 Which cells are instantiated in the netlist (Verilog)

The initialization flow looks like this:

```
        Mux_2x1_sky130.v
               │
               │
      +--------------------+
      |   Technology LEF   |
      |   Cell LEF         |
      |   Liberty (.lib)   |
      +--------------------+
               │
               ▼
          Link Design
               │
               ▼
        OpenROAD Database
         (mux_linked.odb)
```

### Required Files

Your project directory should contain:

```
Mux_2x1_sky130.v
```

The SKY130 PDK provides:

- Technology LEF
- Standard Cell LEF
- Liberty Library

### Step 1 — Go to the Project Directory

```bash
cd /foss/designs/MUX_2x1_RTL_to_GDS
```

Verify:

```bash
pwd
```

Expected:

```
/foss/designs/MUX_2x1_RTL_to_GDS
```

### Step 2 — Launch OpenROAD

```bash
openroad
```

Expected:

```
OpenROAD 26Q2-...
```

### Step 3 — Read the Technology LEF

For our setup:

```
read_lef \
/foss/pdks/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
```

**What is a Tech LEF?**

It defines:

- Manufacturing layers
- Routing layers
- Via definitions
- Site definitions
- Metal rules
- Track information

Without it, OpenROAD has no knowledge of the fabrication technology.

### Step 4 — Read the Standard Cell LEF

```
read_lef /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
```

Expected:

```
[INFO ODB-0227] LEF file ...
created 437 library cells
```

**What is inside the LEF?**

The LEF contains the physical information for every standard cell:

- Width
- Height
- Pin locations
- Obstructions
- Cell boundary

It does not contain transistor layouts.

### Step 5 — Read the Liberty Timing Library

```
read_liberty \
/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

**Why do we need the Liberty file?**

It provides:

- Cell delays
- Setup/Hold timing
- Input capacitance
- Output drive strength
- Power information

Without it, timing analysis cannot be performed.

### Step 6 — Read the Synthesized Netlist

```
read_verilog Mux_2x1_sky130.v
```

This loads the gate-level netlist produced by Yosys.

### Step 7 — Link the Design

This is one of the most important commands.

```
link_design Mux_2x1
```

**⚠ Important**

Notice we use:

```
link_design Mux_2x1
```

NOT

```
link_design Mux_2x1_sky130
```

Why? Because inside the synthesized file:

```
module Mux_2x1(
```

The module name is `Mux_2x1`, while the file name is `Mux_2x1_sky130.v`.

OpenROAD links using the module name, not the filename.

This was one of the issues we encountered and debugged during your project.

### Step 8 — Verify the Design

Check the area:

```
report_design_area
```

Expected:

```
Design area 11 um^2
```

Check cell usage:

```
report_cell_usage
```

Expected:

```
Cell type report:
Multi-Input combinational cell
```

Inspect the instantiated cells:

```
get_cells
```

For our design, this returned:

```
_4_
```

Inspect the instance:

```
report_instance [lindex [get_cells] 0]
```

Expected:

```
Instance _4_

Cell:
sky130_fd_sc_hd__mux2_1

Pins:

A0
A1
S
X
```

This confirms that the synthesized MUX is correctly instantiated.

### Step 9 — Save the Linked Database

```
write_db mux_linked.odb
```

### Step 10 — Exit OpenROAD

```
exit
```

### Verify Generated File

Back in Linux:

```bash
ls
```

Expected:

```
Mux_2x1_sky130.v
mux_linked.odb
```

### Files Generated

After Step 3, your project should contain:

```
Mux_2x1.sv
Mux_2x1_sky130.v
mux_linked.odb
```

### Common Errors & Fixes

**1. Wrong Module Name**

Error:

```
module not found
```

Cause:

```
link_design Mux_2x1_sky130
```

Correct:

```
link_design Mux_2x1
```

**2. Forgot to Read the Netlist**

Error:

```
No design block found
```

Fix: Always execute:

```
read_verilog Mux_2x1_sky130.v
```

before:

```
link_design Mux_2x1
```

**3. Library Cell Not Found**

Cause: Forgot to load:

```
read_lef sky130_fd_sc_hd.lef
```

or

```
read_liberty sky130_fd_sc_hd__tt_025C_1v80.lib
```

**4. Database Block Cannot Be Found**

Error:

```
STA-0202 database block cannot be found
```

This occurs when you try commands like:

```
get_hier_module *
```

before linking the design.

Always:

```
read_verilog ...
link_design ...
```

first.

**5. `get_hier_module *` Doesn't Work**

In the OpenROAD version we used, this command either wasn't supported as expected or returned:

```
module * cannot be found
```

Instead, use:

```
get_cells
```

and

```
report_instance
```

to inspect the design hierarchy.

### Flow Summary

```
Mux_2x1_sky130.v
        │
        ▼
Read Technology LEF
        │
        ▼
Read Standard Cell LEF
        │
        ▼
Read Liberty
        │
        ▼
Read Verilog
        │
        ▼
Link Design
        │
        ▼
Verify Design
        │
        ▼
mux_linked.odb
```

### Output of Step 3

You now have the first physical design database:

```
mux_linked.odb
```

This `.odb` file is the starting point for all physical implementation stages (floorplanning, placement, routing, etc.).

---

## STEP 4 — Floorplanning

### Objective

Create the physical chip floorplan by defining:

- Die Area
- Core Area
- Standard Cell Rows
- Site Information
- Utilization
- Aspect Ratio

At the end of this step, you should have:

```
mux_floorplan.odb
```

### Theory

After synthesis, OpenROAD knows what cells exist, but it doesn't know where to place them.

Floorplanning defines the physical canvas on which placement and routing will happen.

```
            +-----------------------------------+
            |            Die Area               |
            |                                   |
            |  +-----------------------------+  |
            |  |        Core Area            |  |
            |  |                             |  |
            |  |  Standard Cell Rows         |  |
            |  |                             |  |
            |  +-----------------------------+  |
            |                                   |
            +-----------------------------------+
```

### Inputs Required

From Step-3:

```
mux_linked.odb
```

### Step 1 — Launch OpenROAD

```bash
openroad
```

### Step 2 — Load the linked database

```
read_db mux_linked.odb
```

### Step 3 — Find the Correct Site Name

This was the first issue we encountered.

Initially, we tried:

```
get_sites
```

Result:

```
invalid command name "get_sites"
```

Your OpenROAD version does not support this command.

Instead, check the Tech LEF.

Exit OpenROAD:

```
exit
```

Find the Site in the Technology LEF:

```bash
grep -A5 "^SITE" \
/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
```

Output:

```
SITE unithd
  SYMMETRY Y ;
  CLASS CORE ;
  SIZE 0.46 BY 2.72 ;
END unithd
```

Hence, the site is:

```
unithd
```

### Step 4 — Launch OpenROAD Again

```bash
openroad
```

Load the database:

```
read_db mux_linked.odb
```

### Step 5 — Initialize the Floorplan

Command used:

```
initialize_floorplan \
-utilization 30 \
-aspect_ratio 1.0 \
-core_space 2 \
-site unithd
```

**Meaning of Each Option**

**Utilization**

```
-utilization 30
```

Target: 30%

Meaning: Around 30% of the core area will be occupied by cells.

- Lower utilization → ✔ Easier routing
- Higher utilization → ✔ Smaller chip, ✘ More congestion

**Aspect Ratio**

```
-aspect_ratio 1.0
```

Core Width = Core Height → Produces a square floorplan.

**Core Space**

```
-core_space 2
```

Leaves 2 µm between the Die Boundary and Core Boundary for IO pins.

**Site**

```
-site unithd
```

Defines the standard-cell placement rows.

### Expected Output

You should see something similar to:

```
Added 1 rows of 12 site unithd.

Die BBox:
(0.000 0.000)
(10.125 10.125)

Core BBox:
(2.300 2.720)
(7.820 5.440)

Core area:
15.014 um²

Instance area:
11.261 um²

Effective utilization:
75%
```

### Understanding the Output

**Die Area** — Whole chip: `10.125 × 10.125 µm`

**Core Area** — Where cells will be placed: `2.300 ↓ 7.820`

**Standard Cell Rows**

```
Added 1 rows
```

Since only one MUX cell exists, one placement row is enough.

**Effective Utilization**

Although we requested 30%, OpenROAD reported 75%.

Why?

- The design is very small.
- OpenROAD snaps dimensions to legal row/site sizes.
- The final core became smaller than the ideal estimate.

### Verify the Floorplan

```
report_design_area
```

Output:

```
Design area
11 um²
75% utilization
```

### Save the Database

```
write_db mux_floorplan.odb
```

### Exit

```
exit
```

### Generated File

```
mux_floorplan.odb
```

### Common Errors We Encountered

**Error 1**

```
invalid command name "get_sites"
```

Reason: Older OpenROAD version.

Solution: Use `grep "^SITE"` on the Tech LEF.

**Error 2**

```
Library already exists
```

Occurred because we executed `read_lef` again after loading the database.

Don't reload LEF after `read_db` — the `.odb` already contains the library information.

**Error 3**

Utilization different from requested.

Requested: 30% — Obtained: 75%

This is normal for very small designs because OpenROAD snaps the floorplan to legal row/site boundaries.

### Files After Step-4

```
Mux_2x1.sv
Mux_2x1_sky130.v

mux_linked.odb
mux_floorplan.odb
```

### Flow Summary

```
mux_linked.odb
        │
        ▼
Find Site Name (unithd)
        │
        ▼
initialize_floorplan
        │
        ▼
Generate Standard Cell Rows
        │
        ▼
Core Area Created
        │
        ▼
mux_floorplan.odb
```

### Notes for Future Projects

- Always identify the correct site from the technology LEF if your OpenROAD version doesn't support `get_sites`.
- Don't be surprised if the effective utilization differs from the requested value for tiny designs.
- The `.odb` file carries the loaded LEF/library information, so avoid re-reading LEFs after `read_db`.

---

## STEP 5 — Routing Tracks & IO Pin Placement

### Objective

After floorplanning, the next step is to:

- Generate routing tracks
- Place IO pins
- Save the design database

At the end of this step, you'll obtain:

```
mux_pins.odb
```

### Input Required

From Step-4:

```
mux_floorplan.odb
```

### Step 1 — Launch OpenROAD

```bash
openroad
```

### Step 2 — Read the Floorplan Database

```
read_db mux_floorplan.odb
```

### Step 3 — View the Routing Track Information

Routing tracks are defined in:

```bash
cat /foss/pdks/sky130A/libs.tech/librelane/sky130_fd_sc_hd/tracks.info
```

You will see values similar to:

```
li1
met1
met2
met3
met4
met5
```

with their corresponding:

- X Offset
- Y Offset
- X Pitch
- Y Pitch

These values are required for the `make_tracks` command.

### Step 4 — Create Routing Tracks

**Local Interconnect (li1)**

```
make_tracks li1 \
-x_offset 0.23 \
-x_pitch 0.46 \
-y_offset 0.17 \
-y_pitch 0.34
```

**Metal1**

```
make_tracks met1 \
-x_offset 0.17 \
-x_pitch 0.34 \
-y_offset 0.17 \
-y_pitch 0.34
```

**Metal2**

```
make_tracks met2 \
-x_offset 0.23 \
-x_pitch 0.46 \
-y_offset 0.23 \
-y_pitch 0.46
```

**Metal3**

```
make_tracks met3 \
-x_offset 0.34 \
-x_pitch 0.68 \
-y_offset 0.34 \
-y_pitch 0.68
```

**Metal4**

```
make_tracks met4 \
-x_offset 0.46 \
-x_pitch 0.92 \
-y_offset 0.46 \
-y_pitch 0.92
```

**Metal5**

```
make_tracks met5 \
-x_offset 1.70 \
-x_pitch 3.40 \
-y_offset 1.70 \
-y_pitch 3.40
```

### Why are Routing Tracks Required?

Routing tracks define the legal locations where wires can be placed.

Without routing tracks:

- Pins cannot be connected.
- Global routing cannot begin.
- Detailed routing will fail.

Conceptually:

```
---------------------------------
Track 1
---------------------------------
Track 2
---------------------------------
Track 3
---------------------------------
Track 4
```

Every routed wire must lie on these tracks.

### Step 5 — Place IO Pins

Initially, we tried:

```
place_pins \
-hor_layers met2 \
-ver_layers met3
```

which resulted in:

```
PPL-0045
Layer met2 preferred direction is not horizontal.
```

**Why did this happen?**

In SKY130:

| Layer | Preferred Direction |
|-------|---------------------|
| met1  | Horizontal          |
| met2  | Vertical            |
| met3  | Horizontal          |
| met4  | Vertical            |
| met5  | Horizontal          |

Since `met2` is a vertical routing layer, it cannot be used as the horizontal layer.

**Correct Command**

```
place_pins \
-hor_layers met3 \
-ver_layers met2
```

Expected output:

```
Found 0 macro blocks.
Number of available slots : 26
Number of IO Pins : 4
Successfully assigned pins.
I/O nets HPWL : 23.93 um
```

### What Happens Internally?

OpenROAD automatically places:

- `i0`
- `i1`
- `sel`
- `out`

around the chip boundary and assigns them to legal routing tracks.

For our MUX, all four ports were successfully placed.

### Step 6 — Save the Database

```
write_db mux_pins.odb
```

### Step 7 — Exit OpenROAD

```
exit
```

### Output File

```
mux_pins.odb
```

### Common Errors We Encountered

**Error 1**

```
PPL-0045
Layer met2 preferred direction is not horizontal.
```

Reason: Wrong routing layer selection.

Wrong:

```
place_pins \
-hor_layers met2 \
-ver_layers met3
```

Correct:

```
place_pins \
-hor_layers met3 \
-ver_layers met2
```

**Error 2**

Using `-ver_layer` instead of `-ver_layers`.

The correct syntax is:

```
place_pins \
-hor_layers met3 \
-ver_layers met2
```

**Error 3**

Skipping the `make_tracks` step.

Without routing tracks, OpenROAD cannot legally place pins or route wires.

### Files After Step-5

```
Mux_2x1.sv
Mux_2x1_sky130.v
mux_linked.odb
mux_floorplan.odb
mux_pins.odb
```

### Complete Flow of Step-5

```
mux_floorplan.odb
        │
        ▼
Read Floorplan
        │
        ▼
Read tracks.info
        │
        ▼
Create Routing Tracks
        │
        ▼
Place IO Pins
        │
        ▼
Save Database
        │
        ▼
mux_pins.odb
```

### Summary

- Read the floorplan database (mux_floorplan.odb)
- Generated routing tracks for li1 through met5
- Placed the four IO pins (i0, i1, sel, out) using place_pins
- Saved the design as mux_pins.odb for the next stage

---

## STEP 6 — Global Placement & Detailed Placement

### Objective

In this step, OpenROAD determines the best physical location for the standard cells inside the core area while minimizing wire length and avoiding overlaps.

At the end of this step, you will have:

```
mux_global_place.odb
mux_detailed_place.odb
```

### Theory

Until now we have:

- Netlist
- Floorplan
- IO Pins

The standard cell is not yet placed.

Initially, it is floating:

```
+------------------------------------+
|                                    |
|        [MUX Cell]                  |
|                                    |
|                                    |
|                                    |
+------------------------------------+
```

The placer calculates the optimal position.

After placement:

```
+------------------------------------+
| i1                          out     |
|                                    |
|         +---------------+          |
|         | sky130_mux2_1 |          |
|         +---------------+          |
|                                    |
| i0                      sel         |
+------------------------------------+
```

### Input Required

From Step-5:

```
mux_pins.odb
```

### Step 1 — Launch OpenROAD

```bash
openroad
```

### Step 2 — Read the Database

```
read_db mux_pins.odb
```

### Step 3 — Run Global Placement

```
global_placement
```

Expected output (values may vary slightly):

```
Start Nesterov placement

Wirelength = ...

Overflow = ...

Placement converged
```

**What does Global Placement do?**

It tries to minimize:

- Total wire length
- Congestion
- Cell movement

It does not ensure legal placement. Cells may still overlap.

Conceptually:

Before:

```
+---------------------+

 [MUX]

+---------------------+
```

After Global Placement:

```
+---------------------+

        [MUX]

+---------------------+
```

The location is optimized, but legality is not yet guaranteed.

### Step 4 — Save Global Placement

```
write_db mux_global_place.odb
```

### Step 5 — Run Detailed Placement

```
detailed_placement
```

Expected output:

```
Placed 1 instances.

Legalized placement.
```

**What does Detailed Placement do?**

It:

- Removes overlaps
- Snaps cells to placement rows
- Makes placement legal
- Aligns cells with site boundaries

After this step, the design is ready for routing.

### Step 6 — Verify Placement

```
check_placement
```

Expected output:

```
Placement is legal.
```

If no errors are reported, your placement is successful.

### Step 7 — Report Design Area

```
report_design_area
```

Expected output:

```
Design area 11 um^2
75% utilization
```

(Your utilization may differ slightly.)

### Step 8 — Save Detailed Placement

```
write_db mux_detailed_place.odb
```

### Step 9 — Exit

```
exit
```

### Output Files

```
mux_global_place.odb
mux_detailed_place.odb
```

### Understanding Global vs Detailed Placement

| Global Placement | Detailed Placement |
|---|---|
| Finds approximate best position | Makes placement legal |
| Minimizes wire length | Removes overlaps |
| Fast optimization | Final legalization |
| Cells may overlap | No overlaps |

### Common Commands Used

```
read_db mux_pins.odb

global_placement

write_db mux_global_place.odb

detailed_placement

check_placement

report_design_area

write_db mux_detailed_place.odb

exit
```

### Common Errors

**Error 1**

```
No rows defined.
```

Reason: Floorplan was not created correctly.

Always load `mux_floorplan.odb` before creating the placement database.

**Error 2**

```
No placeable instances.
```

Reason: The synthesized netlist was not linked correctly, or the design contains no movable standard cells.

**Error 3**

```
Placement failed because utilization is too high.
```

Reason: The core area is too small.

Increase the floorplan utilization or aspect ratio and rerun the floorplan stage.

### Files After Step-6

```
Mux_2x1.sv
Mux_2x1_sky130.v
mux_linked.odb
mux_floorplan.odb
mux_pins.odb
mux_global_place.odb
mux_detailed_place.odb
```

### Flow Summary

```
mux_pins.odb
       │
       ▼
Read Database
       │
       ▼
Global Placement
       │
       ▼
Save Database
       │
       ▼
Detailed Placement
       │
       ▼
Check Placement
       │
       ▼
Report Design Area
       │
       ▼
Save Database
       │
       ▼
mux_detailed_place.odb
```

### Final Output of Step-6

At the end of this step:

- The standard cell is optimally placed.
- Placement is legalized with no overlaps.
- Design area and utilization are verified.
- The placed design is saved in mux_detailed_place.odb.

This completes the placement phase of the physical design flow.

---

## STEP 7 — Global Routing

### Objective

Global Routing creates a routing plan by determining the paths that interconnect all the nets in the design. At this stage, OpenROAD does not create actual metal wires; instead, it generates routing guides that the detailed router will follow.

At the end of this step, you will have:

```
mux_global_route.odb
```

### Theory

Until now, we have:

- Floorplan ✔
- IO Pins ✔
- Cell Placement ✔

However, the cells are still electrically unconnected.

For example:

```
        i0
         │

      +--------+
      |  MUX   |
      +--------+

         │
        out
```

There are no metal wires yet.

Global Routing determines:

- Which routing layers to use
- The approximate routing path
- Congestion information
- Routing guides for the detailed router

### Input Required

From Step-6:

```
mux_detailed_place.odb
```

### Step 1 — Launch OpenROAD

```bash
openroad
```

### Step 2 — Read the Database

```
read_db mux_detailed_place.odb
```

### Step 3 — Run Global Routing

```
global_route
```

Expected output:

```
Global routing...
Finished global routing.
```

This creates routing guides for every net.

### Step 4 — Save the Routed Database

```
write_db mux_global_route.odb
```

### Step 5 — Report Routing Layer RC

This command displays the resistance and capacitance of each routing layer.

```
report_layer_rc
```

Example output:

```
Layer      Resistance      Capacitance

li1
met1
met2
met3
met4
met5
```

It also reports the resistance of every via:

```
mcon
via
via2
via3
via4
```

**Why is this Important?**

These RC values are later used during:

- Static Timing Analysis (STA)
- Delay calculation
- Power estimation
- Signal integrity analysis

### Step 6 — Report Wire Length

Initially we tried:

```
report_wire_length
```

and received:

```
[ERROR GRT-0238] -net is required.
```

**Why?**

By default, `report_wire_length` expects the name of a specific net.

**Correct command**

To obtain a summary for the entire design:

```
report_wire_length -summary
```

Expected output:

```
Global route wire length by layer
```

### Step 7 — Report Floating Nets

```
report_floating_nets
```

If nothing is printed, ✅ all nets are properly connected.

If floating nets exist, OpenROAD lists them.

### Step 8 — (Optional) Congestion Report

For larger designs, you can generate congestion information.

Example:

```
global_route \
-congestion_report_file congestion.rpt
```

For our MUX design, this wasn't necessary because the design is extremely small.

### Step 9 — Save the Database Again (Optional)

If additional routing modifications were made:

```
write_db mux_global_route.odb
```

### Step 10 — Exit

```
exit
```

### Output File

```
mux_global_route.odb
```

### Commands Used in Step-7

```
read_db mux_detailed_place.odb

global_route

write_db mux_global_route.odb

report_layer_rc

report_wire_length -summary

report_floating_nets

exit
```

### Common Errors We Encountered

**Error 1**

```
[ERROR GRT-0238]
-net is required.
```

Cause: Using `report_wire_length` without specifying a net.

Solution: For the complete design:

```
report_wire_length -summary
```

Or for a specific net:

```
report_wire_length -net out
```

**Error 2**

```
Heat map "IR Drop" has not been populated with data.
```

Cause: No IR-drop analysis has been performed yet.

Solution: This is only a warning and can be ignored at this stage.

**Error 3**

```
QStandardPaths:
runtime directory ...
```

Cause: A WSL GUI permission warning.

Solution: This does not affect routing and can safely be ignored.

### Files After Step-7

```
Mux_2x1.sv
Mux_2x1_sky130.v
mux_linked.odb
mux_floorplan.odb
mux_pins.odb
mux_global_place.odb
mux_detailed_place.odb
mux_global_route.odb
```

### Flow Summary

```
mux_detailed_place.odb
            │
            ▼
      Read Database
            │
            ▼
      Global Routing
            │
            ▼
 Generate Routing Guides
            │
            ▼
 Report Layer RC
            │
            ▼
 Report Wire Length
            │
            ▼
 Check Floating Nets
            │
            ▼
 Save Database
            │
            ▼
mux_global_route.odb
```

### Final Output of Step-7

At the end of this step:

- Global routing guides are generated.
- Routing layer resistance and capacitance are reported.
- Wire length information is available.
- Floating nets are checked.
- The routed design is saved as mux_global_route.odb.

### Important Note (Based on Our Session)

During our project, we discovered that `global_route` does not create the final metal wires. It only generates routing guides. The actual wires, vias, and DRC-clean routing are created in the next stage using the Detailed Router (`detailed_route`).

---

## STEP 8 — Detailed Routing (Final Routing)

### Objective

The detailed router uses the routing guides generated during Global Routing and creates the actual metal interconnections and vias between the pins.

At the end of this step, you will have:

```
mux_detailed_route.odb
drc.rpt
```

### Theory

After Global Routing, OpenROAD only knows the approximate path for each net.

Example:

Global Route

```
i0  -----------+
               |
               |
             MUX
               |
               |
out ----------+
```

These are only routing guides.

Detailed Routing converts them into:

- Actual Metal1 wires
- Metal2 wires
- Vias
- DRC-clean routing

Example:

```
      Metal2
         │
         │
      Via
         │
────────────── Metal1
         │
      Via
         │
      Metal2
```

Now the design is physically connected.

### Input Required

From Step-7:

```
mux_global_route.odb
```

### Step 1 — Launch OpenROAD

```bash
openroad
```

### Step 2 — Read the Global Routed Database

```
read_db mux_global_route.odb
```

### Step 3 — Set Routing Layers

In newer OpenROAD versions, the options:

```
-bottom_routing_layer
-top_routing_layer
```

are deprecated.

Instead, use:

```
set_routing_layers \
-signal met1-met5
```

This tells the detailed router to use routing layers from Metal1 through Metal5 for signal routing.

### Step 4 — Run Detailed Routing

```
detailed_route
```

Expected output:

```
Start detail routing.

Start 0th optimization iteration.

Number of violations = 0.

Complete detail routing.
```

### Step 5 — Generate a DRC Report

To create a report containing routing DRC information:

```
detailed_route \
-output_drc drc.rpt
```

This produces:

```
drc.rpt
```

### Step 6 — Observe the Routing Statistics

Near the end of the routing log, OpenROAD reports useful information.

For our MUX design, we obtained:

```
Total wire length = 20 um.
```

Layer-wise wire length:

```
Layer        Wire Length

li1          0 um
met1         5 um
met2         14 um
met3         0 um
met4         0 um
met5         0 um
```

Total vias:

```
Total number of vias = 8
```

### Step 7 — Check DRC Violations

The most important line is:

```
Number of violations = 0
```

This confirms that the router produced a DRC-clean layout.

### Step 8 — Save the Routed Database

```
write_db mux_detailed_route.odb
```

### Step 9 — Exit OpenROAD

```
exit
```

### Output Files

```
mux_detailed_route.odb
drc.rpt
```

### Commands Used in Step-8

```
read_db mux_global_route.odb

set_routing_layers \
-signal met1-met5

detailed_route

detailed_route \
-output_drc drc.rpt

write_db mux_detailed_route.odb

exit
```

### Common Errors We Encountered

**Error 1**

```
[ERROR DRT-0509]

-bottom_routing_layer is deprecated.
```

Cause: Using the old syntax:

```
detailed_route \
-bottom_routing_layer met1 \
-top_routing_layer met5
```

Solution: Use:

```
set_routing_layers \
-signal met1-met5

detailed_route
```

**Error 2**

Running:

```
detailed_route
```

without first setting the routing layers.

Solution: Always execute:

```
set_routing_layers \
-signal met1-met5
```

before starting the detailed router.

**Error 3**

Running the router without completing Global Routing first.

Solution: The required sequence is:

```
Global Placement
        ↓
Detailed Placement
        ↓
Global Routing
        ↓
Detailed Routing
```

### Files After Step-8

```
Mux_2x1.sv
Mux_2x1_sky130.v
mux_linked.odb
mux_floorplan.odb
mux_pins.odb
mux_global_place.odb
mux_detailed_place.odb
mux_global_route.odb
mux_detailed_route.odb
drc.rpt
```

### Flow Summary

```
mux_global_route.odb
          │
          ▼
   Read Database
          │
          ▼
 Set Routing Layers
          │
          ▼
   Detailed Routing
          │
          ▼
  Generate DRC Report
          │
          ▼
 Verify 0 Violations
          │
          ▼
 Save Database
          │
          ▼
mux_detailed_route.odb
```

### Final Output of Step-8

At the end of this step:

- Routing guides are converted into actual metal wires and vias.
- Signal routing uses Metal1 through Metal5.
- A DRC report (drc.rpt) is generated.
- The design is verified to have 0 DRC violations.
- The fully routed database is saved as mux_detailed_route.odb.

### ⭐ Important Notes from Our Project

During this project, we also observed that:

- `report_wire_length -summary` after Global Routing only reports guide-based estimates.
- The actual routed wire length is reported by the Detailed Router at the end of `detailed_route`.

For our single-cell MUX design:

- Total routed wire length: 20 µm
- Total vias: 8
- DRC violations: 0

This `mux_detailed_route.odb` is the database we later used to generate the final `mux_final.def` and import the routed design into Magic for extraction, LVS netlist generation, and GDS creation.

---

## STEP 9 — Magic Layout Verification, Extraction & GDS Generation

### Objective

In this step, we:

- Import the routed DEF into Magic
- Load the standard cell library
- Expand the hierarchy
- Verify the routed layout
- Extract the layout
- Generate the SPICE netlist
- Generate the final GDSII file

### Theory

Until now OpenROAD has produced:

```
mux_detailed_route.odb
```

and

```
mux_final.def
```

The DEF file contains:

- Cell placement
- Routing
- Pins
- Vias

but not the complete polygon information.

Magic reconstructs the complete layout using:

- Technology file
- Standard cell layouts
- DEF

Then it extracts:

- Netlist
- Parasitics
- GDS

### Required Files

```
mux_final.def
sky130A.tech
sky130_fd_sc_hd.lef
```

### Step 1 — Launch Magic

```bash
magic -T /foss/pdks/sky130A/libs.tech/magic/sky130A.tech
```

### Step 2 — Set the Search Path

This is one of the most important steps.

Magic must know where the standard-cell layouts are located.

```
path search /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/mag
```

Verify:

```
path search
```

Expected output:

```
/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/mag
```

### Step 3 — Read the Standard Cell LEF

```
lef read /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
```

Expected:

```
LEF read:
Processed XXXXX lines.
```

### Step 4 — Read the Routed DEF

Use the correct DEF exported from the routed database.

```
def read /foss/designs/MUX_2x1_RTL_to_GDS/mux_final.def
```

Expected:

```
Processed 1 subcell instance

Processed 4 pins

Processed 4 nets
```

There should be no VIA errors if the DEF was exported from `mux_detailed_route.odb`.

### Step 5 — Select the Top Cell

```
select top cell
```

Verify:

```
what
```

Expected:

```
Selected subcell(s):

Topmost cell

mux_final
```

### Step 6 — Expand the Hierarchy

```
expand all
```

Now the complete standard-cell layout becomes visible.

### Step 7 — Verify the Layout

Check:

- IO pins
- Routing
- Standard cell
- Metal layers
- Labels

You should now see:

- Metal routing
- Cell geometry
- IO pins

### Step 8 — Extract the Layout

```
extract all
```

Expected:

```
Extracting mux_final.ext

Extracting sky130_fd_sc_hd__mux2_1.ext
```

### Step 9 — Generate SPICE

Enable LVS mode:

```
ext2spice lvs
```

Generate SPICE:

```
ext2spice
```

Generated file:

```
mux_final.spice
```

### Step 10 — Generate GDS

```
gds write mux_final.gds
```

Expected output:

```
Copying output for cell

sky130_fd_sc_hd__mux2_1

Generating output for cell

mux_final
```

Generated file:

```
mux_final.gds
```

### Step 11 — Exit Magic

```
quit
```

### Generated Files

```
mux_final.ext
mux_final.spice
mux_final.gds
```

### Commands Used

```
path search /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/mag

lef read /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

def read /foss/designs/MUX_2x1_RTL_to_GDS/mux_final.def

select top cell

what

expand all

extract all

ext2spice lvs

ext2spice

gds write mux_final.gds

quit
```

### Common Errors We Faced (and Their Solutions)

**Error 1**

```
Via name "M1M2_PR" unknown
```

Cause: The DEF was exported before detailed routing.

Solution:

```
read_db mux_detailed_route.odb

write_def mux_final.def
```

Then reload the new DEF in Magic.

**Error 2**

```
Cell is an abstract view

cannot write GDS
```

Cause: Magic loaded the MAGLEF (abstract) cell instead of the MAG (full layout).

Solution: Set the correct search path before reading the DEF:

```
path search /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/mag
```

Avoid using the maglef directory for GDS generation.

**Error 3**

```
Cannot open LEF file
```

Cause: Incorrect LEF path.

Solution: Use:

```
lef read /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
```

**Error 4**

```
load mux_final.mag

No such file
```

Cause: Trying to load the file with the extension.

Solution: Load using only the cell name:

```
load mux_final
```

**Error 5**

```
expand all

The box isn't in the same window as the cursor.
```

Cause: Nothing was selected.

Solution:

```
select top cell

expand all
```

### Files After Step-9

```
Mux_2x1.sv
Mux_2x1_sky130.v
mux_linked.odb
mux_floorplan.odb
mux_pins.odb
mux_global_place.odb
mux_detailed_place.odb
mux_global_route.odb
mux_detailed_route.odb
mux_final.def
mux_final.mag
mux_final.ext
mux_final.spice
mux_final.gds
drc.rpt
```

### Complete Flow Summary

```
mux_detailed_route.odb
          │
          ▼
Export DEF
          │
          ▼
Launch Magic
          │
          ▼
Set MAG Search Path
          │
          ▼
Read LEF
          │
          ▼
Read DEF
          │
          ▼
Expand Hierarchy
          │
          ▼
Verify Layout
          │
          ▼
Extract Layout
          │
          ▼
Generate SPICE
          │
          ▼
Generate GDS
          │
          ▼
mux_final.gds
```

### Final Output of Step-9

At the end of this step:

- ✅ The routed DEF is successfully imported into Magic.
- ✅ The complete standard-cell hierarchy is expanded using the full MAG library.
- ✅ The layout is extracted to produce mux_final.ext.
- ✅ An LVS-compatible SPICE netlist (mux_final.spice) is generated.
- ✅ The final manufacturable GDSII file (mux_final.gds) is created successfully.
- ✅ The complete RTL-to-GDS flow is now finished, and the design is ready for visualization, LVS, or tape-out preparation.

---

## STEP 10 — Final GDS Verification using KLayout

### Objective

In this final step, we verify the generated GDS file using KLayout.

This helps us ensure that:

- The layout is correctly generated.
- Standard cells are present.
- Routing is visible.
- IO pins are correctly connected.
- Metal layers and vias appear as expected.
- The final chip layout is ready for further verification or fabrication.

### Theory

The GDSII file is the industry-standard format used for IC fabrication. It contains the complete geometric description of the integrated circuit, including all polygons, layers, vias, and labels.

Unlike DEF, which describes placement and routing abstractly, GDS contains the actual mask geometry used during manufacturing.

### Input File

```
mux_final.gds
```

### Step 1 — Launch KLayout

From the terminal:

```bash
klayout
```

or

```bash
klayout mux_final.gds
```

### Step 2 — Open the GDS

If KLayout is already open:

```
File
   ↓
Open
   ↓
mux_final.gds
```

or press `Ctrl + O` and select `mux_final.gds`.

### Step 3 — Load the Technology (Optional)

If layer names are not displayed properly:

```
Tools
    ↓
Manage Technologies
```

Select `sky130A` or load the Sky130 technology if required.

### Step 4 — Fit the Entire Layout

Press `F` or:

```
View
   ↓
Zoom Fit
```

This displays the entire design.

### Step 5 — Expand the Hierarchy

If only a single block is visible:

```
View
   ↓
Expand All Cells
```

or click the hierarchy expansion button.

Now you should be able to inspect the complete hierarchy.

### Step 6 — Inspect Different Layers

Use the Layer Panel on the right to enable or disable layers such as:

- li1
- Metal1
- Metal2
- Via
- Via2
- Labels
- Pins

This makes it easier to inspect routing and connectivity.

### Step 7 — Verify the Design

Check the following:

**✔ Standard Cell**

- MUX cell is present.
- Cell orientation is correct.

**✔ Routing**

- Metal1 routing is visible.
- Metal2 routing is visible.
- Vias are correctly placed.

**✔ IO Pins**

Verify that:

```
i0
i1
sel
out
```

are routed correctly to the MUX cell.

**✔ Labels**

Ensure the port labels are present and correspond to the correct pins.

**✔ Bounding Box**

Verify that the layout fits within the expected die area and there are no unexpected polygons outside the boundary.

### Step 8 — Measure (Optional)

Use the ruler tool:

```
Tools
    ↓
Ruler
```

or press `Shift + R` to measure distances or verify dimensions.

### Step 9 — Capture Screenshots

Take screenshots for your documentation or LinkedIn post.

Recommended screenshots:

- Entire layout
- Zoomed MUX cell
- Routed IO connections
- Metal layer view
- Hierarchy view

### Step 10 — Close KLayout

```
File
   ↓
Exit
```

or simply close the application.

### Files Verified

```
mux_final.gds
```

### Checklist

Before considering the design complete, ensure:

- ✅ GDS opens without errors.
- ✅ Standard cell is visible.
- ✅ Metal routing is complete.
- ✅ IO pins (i0, i1, sel, out) are connected.
- ✅ Vias are correctly placed.
- ✅ Labels are visible.
- ✅ No missing geometry or broken connections.
- ✅ Layout matches the Magic view.

### Commands Used

```bash
klayout
```

or

```bash
klayout mux_final.gds
```

### Common Issues

**Problem:** Only one block is visible.

Solution: Use `Expand All Cells` to view the complete hierarchy.

**Problem:** Routing is not visible.

Solution: Enable the relevant routing layers (Metal1, Metal2, Via) from the Layer Panel.

**Problem:** Labels are not visible.

Solution: Enable the Text/Label layer or zoom in further.

### Final Project Files

At the end of the complete flow, your project directory should contain:

```
Mux_2x1.sv                 ← RTL
Mux_2x1_sky130.v           ← Synthesized gate-level netlist
constraints.sdc            ← Timing constraints
mux_linked.odb             ← Linked design database
mux_floorplan.odb          ← Floorplanned database
mux_pins.odb               ← IO pin placement
mux_global_place.odb       ← Global placement
mux_detailed_place.odb     ← Legalized placement
mux_global_route.odb       ← Global routing
mux_detailed_route.odb     ← Detailed routing
mux_final.def              ← Final routed DEF
mux_final.mag              ← Magic layout
mux_final.ext              ← Extracted layout
mux_final.spice            ← Extracted SPICE netlist
mux_final.gds              ← Final GDSII layout
drc.rpt                    ← Detailed routing DRC report
```
