// Representative legacy WebForms code-behind. Deliberately shows the old
// pattern — business logic inline in the click handler, ViewState carrying
// state, no separated service layer — so the modernization discussion in
// docs/legacy-modernization.md has something concrete to point at.
// This file is NOT compiled into the .NET 8 solution.
using System;
using System.Web.UI;

namespace LegacySample
{
    public partial class BenefitApplication : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Legacy pattern: Page_Load + IsPostBack checks govern everything.
            // Modern equivalent: explicit GET (render) vs POST (submit) actions.
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Legacy flaw #1: business logic lives in the UI event handler,
            // so it cannot be unit-tested without spinning up the page.
            // Modern fix: ApplicationService.SubmitAsync + ApplicationValidator
            // (see src/IowaPortal.Application/).
            if (string.IsNullOrWhiteSpace(txtName.Text))
            {
                lblResult.Text = "Enter a name.";
                return;
            }

            // Legacy flaw #2: the "reference number" is invented in the UI
            // layer with no persistence or uniqueness guarantee.
            // Modern fix: repository-backed, uniquely-indexed reference
            // numbers (see Infrastructure/Repositories.cs + DbContext).
            lblResult.Text = "Sample application received for " + Server.HtmlEncode(txtName.Text) + ".";
        }
    }
}
