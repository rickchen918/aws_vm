resource "azurerm_public_ip" "default" {
  count = var.public_ip ? 1 : 0
  name = var.name
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
}

resource "azurerm_network_interface" "default" {
  count = 1
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.name}-int"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public_ip ? azurerm_public_ip.default[count.index].id : null
  }
  depends_on = [
    azurerm_public_ip.default
  ]
}

resource "azurerm_network_security_group" "default" {
  name = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "default-ssh" {
  count = length(var.ssh_source)
  resource_group_name = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
  name = "ssh-from-${split("/",var.ssh_source[count.index])[0]}"
  access = "Allow"
  priority = count.index + 200
  direction = "Inbound"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = var.ssh_source[count.index]
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "default-all" {
  count = 1
  resource_group_name = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
  name = "allow-private-subnet"
  access = "Allow"
  priority = count.index + 400
  direction = "Inbound"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "10.0.0.0/8"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "egress_all_public" {
  name                        = "Any-from-0.0.0.0"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_interface_security_group_association" "default" {
  count = 1
  network_interface_id = azurerm_network_interface.default[count.index].id
  network_security_group_id = azurerm_network_security_group.default.id
}


resource "azurerm_linux_virtual_machine" "deault" {
  count = 1
  name                = "${var.name}-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.default[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.ver
  }

  tags = var.tags

  depends_on = [
    azurerm_network_security_group.default,
    azurerm_public_ip.default,
  ]
}
