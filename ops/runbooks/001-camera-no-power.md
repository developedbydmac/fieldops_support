# Runbook: Camera No Power

**Issue Code**: 001  
**Category**: Camera Diagnostics  
**Estimated Time**: 15-20 minutes  
**Skill Level**: Tier-1  

## Problem Statement
Security camera is not powering on or showing signs of life (no LED indicators, no network connectivity).

## Prerequisites
- Access to network switch/PoE injector
- Basic network tools (cable tester, multimeter)
- Switch management credentials (if managed switch)

## Diagnostic Steps

### Step 1: Visual Inspection (2 minutes)
- [ ] Check camera for physical damage
- [ ] Verify all cable connections are secure
- [ ] Look for LED indicators on camera
- [ ] Check environmental factors (weather, vandalism)

### Step 2: Power Source Verification (5 minutes)
- [ ] **PoE Switch Check**
  - Access switch management interface
  - Verify PoE is enabled on port
  - Check PoE power budget usage
  - Look for error-disabled status
- [ ] **PoE Class Verification**
  - Verify camera PoE class matches switch capability
  - Check power consumption vs. available power
- [ ] **Injector Check** (if using PoE injector)
  - Verify injector power LED
  - Test injector output with multimeter
  - Check input power source

### Step 3: Network Connectivity (5 minutes)
- [ ] **Physical Layer**
  - Test cable continuity with cable tester
  - Check for proper termination (568A/568B)
  - Verify cable length (<100m for Ethernet)
- [ ] **VLAN Configuration**
  - Use LLDP to verify VLAN assignment
  - Check switch port VLAN configuration
  - Verify camera VLAN matches expectations

### Step 4: DHCP and IP Assignment (3 minutes)
- [ ] Check DHCP lease table for camera MAC
- [ ] Verify DHCP scope has available addresses
- [ ] Test DHCP service on camera VLAN
- [ ] Check for IP conflicts

## Resolution Actions

### Power Issues
1. **Insufficient PoE Power**
   - Upgrade to higher wattage PoE+ injector
   - Reconfigure switch PoE allocation
   - Use dedicated power supply if available

2. **Port Error-Disabled**
   - Clear error-disabled state: `no shutdown`
   - Check for PoE faults: `show power inline`
   - Review error logs for root cause

3. **Bad Cable/Connection**
   - Replace Ethernet cable
   - Re-terminate connections
   - Test with known good cable

### Network Issues
1. **VLAN Mismatch**
   - Configure correct VLAN on switch port
   - Update camera VLAN settings (if accessible)
   - Verify VLAN exists and is active

2. **DHCP Problems**
   - Restart DHCP service
   - Add static reservation
   - Configure static IP on camera

## Collect for Escalation
If unable to resolve, collect the following information:

### Network Information
- [ ] Switch model and firmware version
- [ ] Port configuration (`show running-config interface`)
- [ ] PoE status (`show power inline`)
- [ ] Error logs from past 24 hours
- [ ] VLAN configuration details

### Physical Information
- [ ] Cable test results
- [ ] Camera model and power requirements
- [ ] Distance from switch to camera
- [ ] Environmental conditions
- [ ] Photos of connections and setup

### Power Measurements
- [ ] Voltage readings at injector/switch
- [ ] Power consumption readings
- [ ] PoE class detection results

## Escalation Triggers
Escalate to Tier-2 if:
- Hardware replacement required
- Network reconfiguration needed (VLAN changes)
- Persistent power issues after cable replacement
- Camera firmware corruption suspected

## Related Runbooks
- 002-network-connectivity-slow
- 003-vlan-configuration-issues
- 004-dhcp-lease-problems

## Revision History
- v1.0 - Initial version for Phase 1
- TODO: Update based on field experience
