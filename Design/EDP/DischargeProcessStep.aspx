<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DischargeProcessStep.aspx.cs" Inherits="Design_EDP_DischargeProcessStep" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Discharge Process Step</strong>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Add or Remove Discharge Process Step
            </div>
            <table width="100%">
                <tr>
                    <td style="width: 15%; text-align: right;">Discharge Process Step :&nbsp;</td>
                    <td style="width: 65%; text-align: left;">
                        <asp:CheckBoxList ID="chkProcessStep" runat="server" RepeatDirection="Vertical" ClientIDMode="Static" ToolTip="Select Process Step"></asp:CheckBoxList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnUpdate" Text="Update" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" ToolTip="Click To Update" OnClick="btnUpdate_Click" />
        </div>
    </div>
</asp:Content>

