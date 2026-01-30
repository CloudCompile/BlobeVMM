#!/bin/bash
# Microphone test script for BlobeVM
# Tests if microphone access and audio system are working correctly

echo "🔊 BlobeVM Microphone Test Script"
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test 1: Check if running in container
echo -e "${BLUE}Test 1: Container Environment Check${NC}"
if [ -f "/.dockerenv" ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
    echo -e "${GREEN}✅ Running in Docker container${NC}"
else
    echo -e "${YELLOW}⚠️  Not running in Docker container (this script is designed for BlobeVM container)${NC}"
fi
echo ""

# Test 2: Check audio packages
echo -e "${BLUE}Test 2: Audio Package Installation${NC}"
if command -v pulseaudio >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PulseAudio installed${NC}"
else
    echo -e "${RED}❌ PulseAudio not found${NC}"
fi

if command -v arecord >/dev/null 2>&1; then
    echo -e "${GREEN}✅ ALSA utilities installed${NC}"
else
    echo -e "${RED}❌ ALSA utilities not found${NC}"
fi

if command -v pactl >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PulseAudio utilities installed${NC}"
else
    echo -e "${RED}❌ PulseAudio utilities not found${NC}"
fi
echo ""

# Test 3: Check audio devices
echo -e "${BLUE}Test 3: Audio Device Detection${NC}"
if [ -d "/dev/snd" ]; then
    echo -e "${GREEN}✅ Audio devices directory found${NC}"
    echo "   Audio devices:"
    ls -la /dev/snd/ 2>/dev/null | grep -E "pcm|cmp|seq|control" || echo "   No audio device files detected"
else
    echo -e "${YELLOW}⚠️  /dev/snd not found (microphone may not be accessible)${NC}"
fi
echo ""

# Test 4: Check PulseAudio status
echo -e "${BLUE}Test 4: PulseAudio Status${NC}"
if pgrep pulseaudio >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PulseAudio is running${NC}"
    
    # Show PulseAudio info
    if command -v pactl >/dev/null 2>&1; then
        echo "   PulseAudio info:"
        pactl info | head -5
    fi
else
    echo -e "${YELLOW}⚠️  PulseAudio not running (will be started automatically)${NC}"
fi
echo ""

# Test 5: Check ALSA cards
echo -e "${BLUE}Test 5: ALSA Card Detection${NC}"
if command -v aplay >/dev/null 2>&1; then
    echo "   Available ALSA cards:"
    aplay -l 2>/dev/null | grep -E "card [0-9]" || echo "   No ALSA cards detected"
else
    echo -e "${YELLOW}⚠️  aplay not available${NC}"
fi
echo ""

# Test 6: Environment variables
echo -e "${BLUE}Test 6: Audio Environment Variables${NC}"
if [ -n "$PULSE_SERVER" ]; then
    echo -e "${GREEN}✅ PULSE_SERVER set: $PULSE_SERVER${NC}"
else
    echo -e "${YELLOW}⚠️  PULSE_SERVER not set${NC}"
fi

if [ -n "$XDG_RUNTIME_DIR" ]; then
    echo -e "${GREEN}✅ XDG_RUNTIME_DIR set: $XDG_RUNTIME_DIR${NC}"
else
    echo -e "${YELLOW}⚠️  XDG_RUNTIME_DIR not set${NC}"
fi
echo ""

# Test 7: Microphone recording test
echo -e "${BLUE}Test 7: Microphone Recording Test${NC}"
echo "   This will test if your microphone can record audio..."
echo "   Recording for 3 seconds..."

if command -v arecord >/dev/null 2>&1; then
    # Test recording
    timeout 3s arecord -d 1 -f cd -c 2 /tmp/mic_test.wav >/dev/null 2>&1
    if [ -f "/tmp/mic_test.wav" ] && [ -s "/tmp/mic_test.wav" ]; then
        echo -e "${GREEN}✅ Microphone recording successful${NC}"
        echo "   Test file size: $(du -h /tmp/mic_test.wav | cut -f1)"
        
        # Test playback if possible
        if command -v aplay >/dev/null 2>&1; then
            echo "   Playing back test recording..."
            timeout 2s aplay /tmp/mic_test.wav >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Audio playback successful${NC}"
            else
                echo -e "${YELLOW}⚠️  Audio playback failed (no speakers or different issue)${NC}"
            fi
        fi
    else
        echo -e "${YELLOW}⚠️  Microphone recording failed or silent${NC}"
        echo "   This could mean:"
        echo "   - No microphone device available"
        echo "   - Microphone permissions denied"
        echo "   - Microphone is muted or disabled"
    fi
    
    # Clean up
    rm -f /tmp/mic_test.wav
else
    echo -e "${YELLOW}⚠️  arecord not available for testing${NC}"
fi
echo ""

# Test 8: WebRTC/Microphone in browsers
echo -e "${BLUE}Test 8: Browser Microphone Test${NC}"
echo "   To test microphone in your browser:"
echo "   1. Open BlobeVM in your browser: http://localhost:3000"
echo "   2. Open Firefox (pre-installed in BlobeVM)"
echo "   3. Go to: https://www.google.com/search?q=microphone+test"
echo "   4. Click 'Allow' when prompted for microphone access"
echo "   5. Speak into your microphone to test"
echo ""

# Test 9: Permissions check
echo -e "${BLUE}Test 9: Audio Device Permissions${NC}"
if [ -d "/dev/snd" ]; then
    AUDIO_PERMS=$(ls -la /dev/snd/ | grep -E "pcm|cmp|seq|control" | head -1 | awk '{print $1}')
    if [ -n "$AUDIO_PERMS" ]; then
        echo -e "${GREEN}✅ Audio device permissions detected: $AUDIO_PERMS${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not read audio device permissions${NC}"
    fi
fi
echo ""

# Summary
echo -e "${GREEN}🎉 Microphone Test Complete!${NC}"
echo ""
echo -e "${BLUE}If your microphone isn't working, try these steps:${NC}"
echo "1. Ensure you're running BlobeVM with audio device support:"
echo "   docker run ... --device=/dev/snd ..."
echo ""
echo "2. Check if audio devices are available on your host system"
echo ""
echo "3. Test microphone permissions in browser when accessing BlobeVM"
echo ""
echo "4. Restart the BlobeVM container if needed:"
echo "   docker restart BlobeVM-Optimized"
echo ""
echo "5. Check container logs for audio-related errors:"
echo "   docker logs BlobeVM-Optimized"
echo ""

# Show useful commands
echo -e "${BLUE}Useful Commands:${NC}"
echo "- Test audio system: pactl info"
echo "- List audio devices: pactl list sources"
echo "- Test recording: arecord -d 3 -f cd -c 2 test.wav"
echo "- Play test audio: aplay test.wav"
echo "- Monitor audio levels: pavucontrol (GUI)"