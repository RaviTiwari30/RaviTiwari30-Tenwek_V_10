<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Doctor_FooterMaster.aspx.cs" Inherits="Design_EMR_Doctor_FooterMaster" ValidateRequest="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="a" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Doctor Footer</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">

                <asp:Label ID="lblTemplate" runat="server" Text="Template" Visible="False"></asp:Label>
                <asp:DropDownList ID="ddlTemplate" runat="server" CssClass="ItDoseDropdownbox" Width="200px"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlTemplate_SelectedIndexChanged" Visible="False">
                </asp:DropDownList>
                <br />
                <div style="text-align: center;">
                    &nbsp;
                    <ckeditor:ckeditorcontrol ID="txtEditor"  BasePath="~/ckeditor" runat="server" EnterMode="BR"  ></ckeditor:ckeditorcontrol>
                           <%-- <uc:RichText ID="txtEditor" runat="server" />--%>
                </div>


                <br />
                <Ajax:ScriptManager ID="sm1" runat="server" />
                <Ajax:UpdatePanel ID="updTemplate" runat="server">
                    <ContentTemplate>
                        <div class="content" style="text-align: center">
                            <asp:CheckBox ID="chkTemp" runat="server" Text="Save Template" AutoPostBack="True"
                                OnCheckedChanged="chkTemp_CheckedChanged" />
                            <asp:TextBox ID="txtTemplate" runat="Server" Visible="False" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </ContentTemplate>
                </Ajax:UpdatePanel>



           
            <div style="text-align:center">
                <asp:Button ID="btnSaveText" OnClick="btnSaveText_Click" runat="server" CssClass="ItDoseButton" Text="Save" ></asp:Button>

            </div>
             </div>
        </div>

    </form>


</body>
</html>
