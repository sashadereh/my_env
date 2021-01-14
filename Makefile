define safe_cp
	if [ -f $(1) ]; then cp $(1) $(2); fi
endef

define backup
	@mkdir -p ./backup
	@mkdir -p ./backup/.gnupg
	@$(call safe_cp,~/.bashrc,./backup/.bashrc)
	@$(call safe_cp,~/.bash_profile,./backup/.bash_profile)
	@$(call safe_cp,~/.gitconfig,./backup/.gitconfig)
	@$(call safe_cp,~/.gnupg/gpg.conf,./backup/.gnupg/gpg.conf)
	@$(call safe_cp,~/.gnupg/gpg-agent.conf,./backup/.gnupg/gpg-agent.conf)
endef

define restore
	@mkdir -p ~/.gnupg
	@$(call safe_cp,./backup/.bashrc,~/.bashrc)
	@$(call safe_cp,./backup/.bash_profile,~/.bash_profile)
	@$(call safe_cp,./backup/.gitconfig,~/.gitconfig)
	@$(call safe_cp,./backup/.gnupg/gpg.conf,~/.gnupg/gpg.conf)
	@$(call safe_cp,./backup/.gnupg/gpg-agent.conf,~/.gnupg/gpg-agent.conf)
endef

define roll_out
	@mkdir -p ~/.gnupg
	@$(call safe_cp,./bashrc,~/.bashrc)
	@$(call safe_cp,./bash_profile,~/.bash_profile)
	@$(call safe_cp,./gitconfig,~/.gitconfig)
	@$(call safe_cp,./gpg/gpg.conf,~/.gnupg/gpg.conf)
	@$(call safe_cp,./gpg/gpg-agent.conf,~/.gnupg/gpg-agent.conf)
endef

all: install

install:
	@$(call backup)

	@$(call roll_out)
	
	@echo 'Environment successfully rolled out'

clean:
	@$(call restore)

	@echo 'Environment successfully restored from backup'
