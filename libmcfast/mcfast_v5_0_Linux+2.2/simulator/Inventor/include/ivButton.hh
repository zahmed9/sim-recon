#ifndef IVBUTTONS
#define IVBUTTONS
enum ButtonTypes {
    IV_SEPARATOR,
    IV_PUSH_BUTTON,
    IV_TOGGLE_BUTTON,
    IV_RADIO_BUTTON,
};

struct ivButton {
   // Widget Button;
    char *name;
    int   id;
    int   buttonType;  // PUSH, TOGGLE, RADIO
    char *accelerator; // e.g. "Alt <Key> p"
    char *accelText;   // text that appears in the menu item
};

struct ivMenuItem {
    class mcfWindow *mcfWin;
    int    id;
    Widget widget;
};

struct ivMenu {
    char  *name;
    int    id;
    struct ivButton *subMenu;
    int    subItemCount;
};
#endif
