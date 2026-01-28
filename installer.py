from textual.app import App, ComposeResult
from textual.screen import Screen
from textual.containers import Horizontal, Vertical
from textual.widgets import Footer, Header, SelectionList, Label, Button, Markdown, Select, Static, Switch

### JSON Exporter ###

def savejson(json):
    with open('options.json', 'w') as f:
        f.write(str(json).replace("'", '"').replace("True", "true").replace("False", "false"))

#####################

Head="""
# BlobeVM Optimized Installer

> BlobeVM Optimized (Powered by DesktopOnCodespaces)

BlobeVM Optimized is a ultra-fast Virtual Machine that...
* Runs entirely in a web browser
* Uses only XFCE4 for maximum speed
* Optimized for GitHub Codespace (2 core, 8GB RAM)
* Is unblocked
* Has Windows app support
* Has audio support
* Can run games with almost no lag
* Can Bypass School Network
* Is very fast
"""
InstallHead="""
# BlobeVM Optimized Installer
Optimized for XFCE4 only - Maximum Speed
"""

class InstallScreen(Screen):
    CSS_PATH = "installer.tcss"

    def compose(self) -> ComposeResult:
        yield Header()
        yield Markdown(InstallHead)
        yield Horizontal (
        Vertical (
         Label("Essential Apps (Pre-selected for speed)"),
         SelectionList[int]( 
            ("Firefox", 0, True),
            ("XFCE4 Terminal", 1, True),
            ("Mousepad", 2, True),
            id="defaultapps"
        ),),
        Vertical (
         Label("Optional Apps"),
         SelectionList[int]( 
            ("Wine", 0),
            ("VLC", 1),
            ("LibreOffice", 2),
            ("Discord", 3),
            ("Steam", 4),
            ("Minecraft", 5),
            ("VSCodium", 6),
            ("Synaptic", 7),
            ("AQemu (VMs)", 8),
            ("TLauncher", 9),
            id="apps"
        ),),
        Vertical (
         Label("Performance"),
         SelectionList[int]( 
            ("Enable KVM Acceleration", 0, True),
            ("Optimize Memory Usage", 1, True),
            ("Enable Hardware Acceleration", 2, True),
            id="performance"
        ),),
        )

        yield Vertical (
         Horizontal(
            Label("\nDesktop Environment: "),
            Static("XFCE4 (Optimized for Speed)", id="de"),
         ),)
        yield Horizontal (
            Button.error("Back", id="back"),
            Button.warning("Install NOW", id="in"),
        )
    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "back":
            app.pop_screen()
        if event.button.id == "in":
            # Always use XFCE4 for speed
            data = {
                "defaultapps": self.query_one("#defaultapps").selected,
                "apps": self.query_one("#apps").selected,
                "performance": self.query_one("#performance").selected,
                "enablekvm": True,
                "DE": "XFCE4 (Lightweight)",
                "optimized": True
            }
            savejson(data)
            app.exit()

class InstallApp(App):
    CSS_PATH = "installer.tcss"

    def compose(self) -> ComposeResult:
        yield Header()
        yield Markdown(Head)
        
        yield Vertical (
            Button.success("Install Optimized BlobeVM", id="install"),
        )
    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "cancel":
            print("")
        if event.button.id == "install":
            self.push_screen(InstallScreen())
            
if __name__ == "__main__":
    app = InstallApp()
    app.run()