const app = {
    currentTab: 'head',
    data: {},
    maxValues: {},
    
    tabs: {
        head: ['hat', 'mask', 'glass', 'ear'],
        body: ['tshirt', 'torso', 'vest', 'arms', 'decals'],
        legs: ['pants', 'shoes'],
        accessories: ['backpack', 'watch', 'bracelet', 'accessory']
    },

    labels: {
        hat: 'Chapéu',
        mask: 'Máscara',
        glass: 'Óculos',
        ear: 'Orelha',
        tshirt: 'Camiseta',
        torso: 'Jaqueta',
        vest: 'Colete',
        arms: 'Braços',
        decals: 'Adesivos',
        pants: 'Calça',
        shoes: 'Sapatos',
        backpack: 'Mochila',
        watch: 'Relógio',
        bracelet: 'Pulseira',
        accessory: 'Acessório'
    },

    open: function(payload) {
        this.data = payload.Current;
        this.maxValues = payload.Max;
        document.getElementById('app').style.display = 'block';
        this.renderTabs();
        this.renderContent();
    },

    close: function() {
        document.getElementById('app').style.display = 'none';
        fetch(`https://${GetParentResourceName()}/Reset`, {
            method: 'POST',
            body: JSON.stringify({})
        });
    },

    renderTabs: function() {
        const tabsContainer = document.querySelector('.tabs');
        tabsContainer.innerHTML = '';

        Object.keys(this.tabs).forEach(tabKey => {
            const tabEl = document.createElement('div');
            tabEl.className = `tab ${this.currentTab === tabKey ? 'active' : ''}`;
            tabEl.onclick = () => {
                this.currentTab = tabKey;
                this.renderTabs();
                this.renderContent();
                this.playClickSound();
            };
            
            // Clothing icons for tabs
            let iconPath = '';
            if (tabKey === 'head') {
                // Hat Icon
                iconPath = `<path d="M32.3578 22.3889H4.64586C3.72782 22.3889 2.86333 21.9566 2.3125 21.2222C1.53472 20.1852 1.53472 18.7592 2.3125 17.7222C2.86333 16.9878 3.72779 16.5555 4.64583 16.5555H32.3542C33.2722 16.5555 34.1367 16.9878 34.6875 17.7222C35.4653 18.7592 35.4653 20.1852 34.6875 21.2222C34.1367 21.9566 33.2759 22.3889 32.3578 22.3889Z" stroke="currentColor" stroke-width="2"/>
                <path d="M 6.833 16.556 L 6.833 5.207 C 6.833 4.168 7.218 3.165 7.913 2.393 C 8.711 1.506 9.847 1 11.04 1 L 13.837 1 L 25.959 1 C 27.152 1 28.289 1.506 29.086 2.393 C 29.782 3.165 30.166 4.168 30.166 5.207 L 30.166 16.556" stroke="currentColor" stroke-width="2"/>`;
            }
            if (tabKey === 'body') {
                // Shirt Icon
                iconPath = `<path fill="currentColor" d="M6 1V0C5.73478 0 5.48043 0.105357 5.29289 0.292893L6 1ZM1 6L0.292893 5.29289C0.0808085 5.50498 -0.0248817 5.80106 0.00496281 6.0995L1 6ZM11 1H12C12 0.447715 11.5523 0 11 0V1ZM11.3806 2.91342L10.4567 3.2961L10.4567 3.2961L11.3806 2.91342ZM12.4645 4.53553L11.7574 5.24264L11.7574 5.24264L12.4645 4.53553ZM14.0866 5.6194L14.4693 4.69552L14.4693 4.69552L14.0866 5.6194ZM17.9134 5.6194L18.2961 6.54328L18.2961 6.54328L17.9134 5.6194ZM19.5355 4.53553L20.2426 5.24264L20.2426 5.24264L19.5355 4.53553ZM20.6194 2.91342L21.5433 3.2961L21.5433 3.2961L20.6194 2.91342ZM21 1V0C20.4477 0 20 0.447715 20 1L21 1ZM26 1L26.7071 0.292893C26.5196 0.105357 26.2652 0 26 0V1ZM31 6L31.995 6.0995C32.0249 5.80106 31.9192 5.50498 31.7071 5.29289L31 6ZM30.1667 14.3333L29.6522 15.1908C29.9459 15.367 30.3093 15.3807 30.6154 15.227C30.9215 15.0733 31.1276 14.7736 31.1617 14.4328L30.1667 14.3333ZM26 11.8333L26.5145 10.9758C26.2056 10.7905 25.8208 10.7856 25.5073 10.9631C25.1938 11.1406 25 11.4731 25 11.8333H26ZM26 27.6667V28.6667C26.5523 28.6667 27 28.219 27 27.6667H26ZM6 27.6667H5C5 28.219 5.44772 28.6667 6 28.6667V27.6667ZM6 11.8333H7C7 11.4731 6.80621 11.1406 6.4927 10.9631C6.17919 10.7856 5.79443 10.7905 5.4855 10.9758L6 11.8333ZM1.83333 14.3333L0.838296 14.4328C0.872377 14.7736 1.07851 15.0733 1.38459 15.227C1.69068 15.3807 2.05413 15.367 2.34783 15.1908L1.83333 14.3333ZM5.29289 0.292893L0.292893 5.29289L1.70711 6.70711L6.70711 1.70711L5.29289 0.292893ZM11 0H6V2H11V0ZM12.3045 2.53073C12.1035 2.04543 12 1.52529 12 1H10C10 1.78793 10.1552 2.56815 10.4567 3.2961L12.3045 2.53073ZM13.1716 3.82843C12.8001 3.45699 12.5055 3.01604 12.3045 2.53073L10.4567 3.2961C10.7583 4.02405 11.2002 4.68549 11.7574 5.24264L13.1716 3.82843ZM14.4693 4.69552C13.984 4.4945 13.543 4.19986 13.1716 3.82843L11.7574 5.24264C12.3145 5.79979 12.9759 6.24175 13.7039 6.54328L14.4693 4.69552ZM16 5C15.4747 5 14.9546 4.89654 14.4693 4.69552L13.7039 6.54328C14.4319 6.84481 15.2121 7 16 7V5ZM17.5307 4.69552C17.0454 4.89654 16.5253 5 16 5V7C16.7879 7 17.5681 6.84481 18.2961 6.54328L17.5307 4.69552ZM18.8284 3.82843C18.457 4.19986 18.016 4.4945 17.5307 4.69552L18.2961 6.54328C19.0241 6.24175 19.6855 5.79979 20.2426 5.24264L18.8284 3.82843ZM19.6955 2.53073C19.4945 3.01604 19.1999 3.45699 18.8284 3.82843L20.2426 5.24264C20.7998 4.68549 21.2417 4.02406 21.5433 3.2961L19.6955 2.53073ZM20 1C20 1.52529 19.8965 2.04543 19.6955 2.53074L21.5433 3.2961C21.8448 2.56815 22 1.78793 22 1H20ZM26 0H21V2H26V0ZM25.2929 1.70711L30.2929 6.70711L31.7071 5.29289L26.7071 0.292893L25.2929 1.70711ZM30.005 5.9005L29.1716 14.2338L31.1617 14.4328L31.995 6.0995L30.005 5.9005ZM30.6812 13.4758L26.5145 10.9758L25.4855 12.6908L29.6522 15.1908L30.6812 13.4758ZM27 27.6667V11.8333H25V27.6667H27ZM6 28.6667H26V26.6667H6V28.6667ZM5 11.8333V27.6667H7V11.8333H5ZM2.34783 15.1908L6.5145 12.6908L5.4855 10.9758L1.31884 13.4758L2.34783 15.1908ZM0.00496281 6.0995L0.838296 14.4328L2.82837 14.2338L1.99504 5.9005L0.00496281 6.0995Z" fill="currentColor"/>`;
            }
            if (tabKey === 'legs') {
                // Pants Icon
                iconPath = `<path d="M10.1678 27.67L11.7951 16.2788C11.8213 16.0954 11.8769 15.9174 11.9598 15.7517V15.7517C12.595 14.4812 14.4081 14.4812 15.0433 15.7517V15.7517C15.1262 15.9174 15.1818 16.0954 15.208 16.2788L16.8353 27.67H26.0031V1H1V27.67H10.1678ZM1 7.6675L1.33331 7.7281C5.11903 8.41641 7.76729 4.73289 6.83406 1V1C8.28378 4.62428 5.17672 8.4269 1.33621 7.72863L1 7.6675Z" stroke="currentColor" stroke-width="2"/>
                <path d="M26.3662 7.6675L26.03 7.72863C22.1895 8.4269 19.0824 4.62428 20.5321 1" stroke="currentColor" stroke-width="2"/>`;
            }
            if (tabKey === 'accessories') {
                // Watch Icon
                iconPath = `<circle cx="12.5" cy="17.6666" r="11.5" stroke="currentColor" stroke-width="2"/>
                <path d="M12.5 11.4166V17.6666H18.75" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                <path d="M5.25 34.3333C5.25 34.8856 5.69772 35.3333 6.25 35.3333C6.80228 35.3333 7.25 34.8856 7.25 34.3333H5.25ZM17.75 34.3333C17.75 34.8856 18.1977 35.3333 18.75 35.3333C19.3023 35.3333 19.75 34.8856 19.75 34.3333H17.75ZM7.25 34.3333V27.0416H5.25V34.3333H7.25ZM19.75 34.3333V27.0416H17.75V34.3333H19.75Z" fill="currentColor"/>
                <path d="M19.75 0.99996C19.75 0.447675 19.3023 -4.04602e-05 18.75 -4.04119e-05C18.1977 -4.03637e-05 17.75 0.447675 17.75 0.99996L19.75 0.99996ZM7.25 0.999961C7.25 0.447676 6.80228 -3.93674e-05 6.25 -3.93192e-05C5.69772 -3.92709e-05 5.25 0.447676 5.25 0.999961L7.25 0.999961ZM17.75 0.99996L17.75 8.29163L19.75 8.29163L19.75 0.99996L17.75 0.99996ZM5.25 0.999961L5.25 8.29163L7.25 8.29163L7.25 0.999961L5.25 0.999961Z" fill="currentColor"/>`;
            }

            // Adjust viewbox for specific icons if needed, but the container handles scaling usually.
            // However, SVG viewboxes in the files were different:
            // Hat: 0 0 37 24
            // Shirt: 0 0 32 29
            // Pants: 0 0 28 29
            // Watch: 0 0 25 36
            
            // We need to set the viewBox dynamically.
            let viewBox = '0 0 24 24';
            if (tabKey === 'head') viewBox = '0 0 37 24';
            if (tabKey === 'body') viewBox = '0 0 32 29';
            if (tabKey === 'legs') viewBox = '0 0 28 29';
            if (tabKey === 'accessories') viewBox = '0 0 25 36';

            tabEl.innerHTML = `<svg viewBox="${viewBox}">${iconPath}</svg>`;
            tabsContainer.appendChild(tabEl);
        });
    },

    renderContent: function() {
        const contentContainer = document.querySelector('.content');
        contentContainer.innerHTML = '';

        const categories = this.tabs[this.currentTab];
        categories.forEach(cat => {
            if (!this.maxValues[cat]) return;

            const item = document.createElement('div');
            item.className = 'category-item';

            const label = document.createElement('div');
            label.className = 'category-label';
            label.textContent = this.labels[cat] || cat;
            item.appendChild(label);

            const controls = document.createElement('div');
            controls.className = 'controls';

            // Item Control
            const itemGroup = this.createControlGroup(cat, 'item');
            controls.appendChild(itemGroup);

            // Texture Control
            const textureGroup = this.createControlGroup(cat, 'texture');
            controls.appendChild(textureGroup);

            item.appendChild(controls);
            contentContainer.appendChild(item);
        });

        // Setup Camera Buttons
        document.querySelectorAll('.cam-btn').forEach(btn => {
            btn.onclick = () => {
                document.querySelectorAll('.cam-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                
                const camType = btn.dataset.cam;
                fetch(`https://${GetParentResourceName()}/Setup`, {
                    method: 'POST',
                    body: JSON.stringify({ value: camType })
                });
            };
        });
    },

    createControlGroup: function(category, type) {
        const group = document.createElement('div');
        group.className = 'control-group';

        const prevBtn = document.createElement('div');
        prevBtn.className = 'control-btn';
        prevBtn.textContent = '<';
        prevBtn.onclick = () => this.updateValue(category, type, -1);

        const valueDisplay = document.createElement('input');
        valueDisplay.className = 'control-value';
        valueDisplay.type = 'number';
        valueDisplay.value = this.data[category][type];
        
        valueDisplay.onchange = (e) => {
            let val = parseInt(e.target.value);
            if (isNaN(val)) val = 0;
            this.setValue(category, type, val);
        };

        const nextBtn = document.createElement('div');
        nextBtn.className = 'control-btn';
        nextBtn.textContent = '>';
        nextBtn.onclick = () => this.updateValue(category, type, 1);

        group.appendChild(prevBtn);
        group.appendChild(valueDisplay);
        group.appendChild(nextBtn);

        return group;
    },

    setValue: function(category, type, value) {
        let max = 0;
        if (type === 'item') {
            max = this.maxValues[category].item;
        } else {
            max = this.maxValues[category].texture;
        }

        if (value < 0) value = max;
        if (value > max) value = 0;

        this.data[category][type] = value;

        if (type === 'item') {
            this.data[category].texture = 0;
        }
        
        this.renderContent();

        fetch(`https://${GetParentResourceName()}/update`, {
            method: 'POST',
            body: JSON.stringify(this.data)
        }).then(resp => resp.json()).then(newMax => {
            this.maxValues = newMax;
             // If max values changed (e.g. texture count), we might need to re-validate current values
             // But usually it's fine.
        });

        if (type === 'item') {
             fetch(`https://${GetParentResourceName()}/Setup`, {
                method: 'POST',
                body: JSON.stringify({ value: category })
            });
        }
    },

    updateValue: function(category, type, change) {
        let current = this.data[category][type];
        let max = 0;
        
        if (type === 'item') {
            max = this.maxValues[category].item;
        } else {
            max = this.maxValues[category].texture;
        }

        let newValue = current + change;

        if (newValue < 0) newValue = max;
        if (newValue > max) newValue = 0;

        this.data[category][type] = newValue;

        // Reset texture if item changed
        if (type === 'item') {
            this.data[category].texture = 0;
        }
        
        // Update display
        this.renderContent();

        // Send update to server
        fetch(`https://${GetParentResourceName()}/update`, {
            method: 'POST',
            body: JSON.stringify(this.data)
        }).then(resp => resp.json()).then(newMax => {
            // Update max values as texture count might change based on item
            this.maxValues = newMax;
            // Re-render to update texture max limits if needed
             this.renderContent();
        });

        // Update camera focus
        if (type === 'item') {
             fetch(`https://${GetParentResourceName()}/Setup`, {
                method: 'POST',
                body: JSON.stringify({ value: category })
            });
        }
    },

    playClickSound: function() {
        // Optional: Add sound effect
    },

    rotate: function(dir) {
        fetch(`https://${GetParentResourceName()}/Rotate`, {
            method: 'POST',
            body: JSON.stringify(dir)
        });
    },

    save: function() {
        fetch(`https://${GetParentResourceName()}/Save`, {
            method: 'POST',
            body: JSON.stringify(this.data)
        });
        document.getElementById('app').style.display = 'none';
    }
};

window.addEventListener('message', function(event) {
    if (event.data.name === 'open') {
        app.open(event.data.payload);
    }
});

// Setup event listeners for static buttons
document.addEventListener('DOMContentLoaded', () => {
    document.querySelector('.btn-confirm').addEventListener('click', () => app.save());
    
    // Rotation controls
    document.querySelector('.rotate-left').addEventListener('click', () => app.rotate('Left'));
    document.querySelector('.rotate-right').addEventListener('click', () => app.rotate('Right'));

    // Rotation Slider Logic
    const sliderTrack = document.querySelector('.slider-track');
    const sliderThumb = document.querySelector('.slider-thumb');
    let isDragging = false;
    let startX = 0;
    let lastTriggerX = 0;
    
    if (sliderThumb && sliderTrack) {
        sliderThumb.addEventListener('mousedown', (e) => {
            isDragging = true;
            startX = e.clientX;
            lastTriggerX = e.clientX;
            sliderThumb.style.transition = 'none';
        });

        window.addEventListener('mousemove', (e) => {
            if (!isDragging) return;
            
            const currentX = e.clientX;
            const totalDelta = currentX - startX;
            
            // Visual feedback (clamp to track bounds)
            const rect = sliderTrack.getBoundingClientRect();
            const maxDrag = (rect.width / 2); 
            const clampedDelta = Math.max(-maxDrag, Math.min(maxDrag, totalDelta));
            sliderThumb.style.transform = `translate(calc(-50% + ${clampedDelta}px), -50%)`;
            
            // Rotation Trigger
            const sensitivity = 2; // Pixels per rotation step
            
            while (currentX - lastTriggerX > sensitivity) {
                app.rotate('Right');
                lastTriggerX += sensitivity;
            }

            while (currentX - lastTriggerX < -sensitivity) {
                app.rotate('Left');
                lastTriggerX -= sensitivity;
            }
        });

        window.addEventListener('mouseup', () => {
            if (isDragging) {
                isDragging = false;
                sliderThumb.style.transform = 'translate(-50%, -50%)';
                sliderThumb.style.transition = 'transform 0.3s';
            }
        });
    }
});
