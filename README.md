# Project Brief: Smart 3S Li-ion UPS & Fan Controller (Dual-Zone Sensing)

## 1. System Overview

Design a professional-grade Arduino-based Fan Controller and Power Management system for a custom PCB. The device manages three high-end 12V PWM fans and features a full battery backup (UPS) system.

**Physical Configuration:**

- **Control Box (3D Printed):** Houses the Arduino Nano, 16x2 LCD, PEC11 Encoder, Battery Pack, and an **Internal Safety Temperature Sensor**.

- **Fan Housing (Wood):** Houses 3x 12V PWM fans and a **Deported Environmental Sensor** (Temperature, Humidity, Pressure) for ambient weather data.

---

## 2. Power Architecture Requirements

- **Dual-Input Power Path:** - Primary: 15V DC Wall Adapter.

    - Backup: 3S Li-ion Battery Pack (Nominal 11.1V, Max 12.6V).

- **Load Sharing:** Run fans/logic and charge the battery simultaneously. Seamless switching to battery when unplugged.

- **Logic Rail:** High-efficiency Step-Down (Buck) regulation to 5V for logic components.

- **Battery Monitoring:** I2C-based sensing for real-time Voltage, Current (mA), and Power (Watts).

- **Capacity Assumption:** 6000mAh (3S2P configuration).

---

## 3. Safety & Protection Requirements

- **Thermal Safety:** Monitor the **Internal Control Box Temperature**. If the internal electronics/battery compartment exceeds a safe threshold (e.g., 55°C), trigger an alert or shutdown.

- **Hardware Protection:** Implementation of a 3S BMS (Battery Management System).

- **Software-Controlled Safety Switch:** High-Side Load MOSFET controlled by Arduino (Pin D6) to disconnect power if:

    - Critical Undervoltage (<9.6V).

    - Overcurrent/Short-circuit (>2A).

    - Critical Internal Overheat.

---

## 4. Actuators & Interface

- **Fan Control:** 3x Fans on **Pin D9**. 25kHz Ultrasonic PWM (Timer 1) for silent operation.

- **User Interface:**

    - **Input:** PEC11 Rotary Encoder with push-button (D2/D3/D5).

    - **Display:** 16x2 LCD via I2C.

- **Dual-Zone I2C Sensors:**

    - **Sensor A (Internal):** Temperature only (for box safety).

    - **Sensor B (Remote):** Temperature, Humidity, Pressure (Deported to the wooden fan housing).

- **Power Saving (Night Mode):**

    - LCD backlight controlled via MOSFET on **Pin D4**.

    - 30-second inactivity timeout; wake on encoder interaction.

---

## 5. Software Logic (State Machine)

- **Navigation:** Rotate encoder to scroll through pages:

    1. **Weather (Remote):** Ambient Temp, Humidity, Pressure.

    2. **System Health (Internal):** Box Temp, Battery Voltage, Current Draw, and "Time Remaining."

    3. **Fan Pages (1-3):** Individual speed and status for each fan.

- **Interaction:** Short Press to Edit Speed (0-100%); Long Press (1s) to Toggle Fan ON/OFF.

- **Fault Handling:** If a fault (Overheat/Overcurrent/Low-V) is detected, pull D6 LOW and display specific error.

---

## 6. Requested Deliverables

1. **Component Proposals:** Specific high-efficiency parts for the 3S Charger, Power Path, Current Sensor, Buck Regulator, and MOSFETs.

2. **Dual-Sensor Strategy:** Propose the best I2C sensors to avoid address conflicts (e.g., using different addresses or an I2C multiplexer).

3. **Firmware:** Complete, non-blocking Arduino C++ code (`.ino`) including 25kHz PWM and safety logic.

4. **Wiring/PCB Guidance:** Advice on routing the deported I2C sensor to the wooden box over a distance while maintaining signal integrity (pull-up resistor placement).



