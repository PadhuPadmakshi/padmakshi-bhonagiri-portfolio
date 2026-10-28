<%-- Representative legacy WebForms page. NOT compiled into the .NET 8 solution:
     WebForms does not run on .NET 8. Kept as reviewable evidence of legacy
     fluency. See docs/legacy-modernization.md for the analysis.
     Fictional sample data only. --%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BenefitApplication.aspx.cs" Inherits="LegacySample.BenefitApplication" %>
<!DOCTYPE html>
<html lang="en">
<head><title>Sample Application (legacy)</title></head>
<body>
  <form id="form1" runat="server">
    <h1>Sample Application (legacy WebForms example)</h1>
    <div>
      <asp:Label ID="lblProgram" runat="server" AssociatedControlID="ddlProgram" Text="Program:" />
      <asp:DropDownList ID="ddlProgram" runat="server">
        <asp:ListItem Text="Food Assistance (sample)" Value="Food" />
        <asp:ListItem Text="Health Coverage (sample)" Value="Health" />
      </asp:DropDownList>
    </div>
    <div>
      <asp:Label ID="lblName" runat="server" AssociatedControlID="txtName" Text="Name:" />
      <asp:TextBox ID="txtName" runat="server" />
      <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
        ErrorMessage="Enter a name." Display="Dynamic" />
    </div>
    <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
    <asp:Label ID="lblResult" runat="server" />
  </form>
</body>
</html>
