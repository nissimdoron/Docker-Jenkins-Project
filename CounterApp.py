import tkinter as tk #for the GUI
from pynput import mouse
import threading


class ClickCounterApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Click Counter")
        self.root.geometry("300x150")
        self.root.resizable(False, False)

        self.click_count = 0

        self.label = tk.Label(root, text="Clicks: 0", font=("Helvetica", 24))
        self.label.pack(pady=40)

        # Start mouse listener in a separate thread
        listener_thread = threading.Thread(target=self.start_mouse_listener, daemon=True)
        listener_thread.start()

    def start_mouse_listener(self):
        with mouse.Listener(on_click=self.on_click) as listener:
            listener.join()

    def on_click(self, x, y, button, pressed):
        if pressed:
            self.click_count += 1
            self.label.config(text=f"Clicks: {self.click_count}")


if __name__ == "__main__":
    root = tk.Tk()
    app = ClickCounterApp(root)
    root.mainloop()

