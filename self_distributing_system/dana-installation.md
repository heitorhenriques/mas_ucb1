# Dana Installation

To run the project without using Docker, you need to install the Dana programming language, specifically version 253.

Download version 253 using the links below:  
- [Windows 64-bit](https://www.projectdana.com/download/win64/253)  
- [Windows 32-bit](https://www.projectdana.com/download/win32/253)  
- [Linux 64-bit](https://www.projectdana.com/download/ubu64/253)  
- [Linux 32-bit](https://www.projectdana.com/download/ubu32/253)  
- [Mac OS](https://www.projectdana.com/download/osx/253)  

Inside the compressed installation file, you will find a `HowToInstall.txt` file with detailed installation instructions specific to the selected operating system.

### General Installation Process

1. **Decompress the `.zip` file** you downloaded.  
2. **Add the directory containing the `dnc` and `dana` files** to your system's environment variables.  
   - This ensures that the executables can be accessed from the terminal regardless of the working directory.  

### Testing the Installation

To verify the installation, run the following command in your terminal:

```bash
dana app.SysTest
```