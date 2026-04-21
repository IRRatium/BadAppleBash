# BadAppleBash (Perfect Sync Edition)

![Design sem nome](https://github.com/user-attachments/assets/329e599e-2284-4d9d-8936-3c166f85334d)

This project reproduces the ["Bad Apple!!"](https://youtu.be/9lNZ_Rnr7Jc?si=ROgXrVvdx13oKPM4) video using a Bash wrapper, with all graphics rendered in ASCII art.

Unlike previous versions, this fork utilizes embedded **Python 3** to process frames. This brings major improvements:
- ⏱️ **Perfect Audio/Video Synchronization:** Frame timings are tied to the system clock, completely eliminating audio drift regardless of terminal speed.
- 🎯 **Automatic Centering:** The video automatically centers itself in your terminal and adapts in real-time if you resize the window.
- 🎵 **Auto-Audio:** Seamlessly starts background audio using `mpv`.

- Why?
- Why not :P

## Requirements
- `python3` (Pre-installed on most Unix/Linux systems)
- `mpv` (Required for audio playback)

## Usage Instructions
01. Clone the repository to your local environment:
```bash
git clone https://github.com/IRRatium/BadAppleBash
```

02. Navigate to the project directory:
```bash
cd YOUR_REPO_NAME
```

03. Make the `run.sh` script executable:
```bash
chmod +x run.sh
```

04. Run the script:
```bash
./run.sh
```

---

## Credits

This project is a fork of [FelipeFMA/BadAppleBash](https://github.com/FelipeFMA/BadAppleBash), which in turn was originally forked from[trung-kieen/bad-apple-ascii](https://github.com/trung-kieen/bad-apple-ascii). 

Special thanks to the original creators for extracting the frames and writing the initial scripts!
