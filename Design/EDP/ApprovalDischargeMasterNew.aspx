<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ApprovalDischargeMasterNew.aspx.cs" Inherits="Design_EDP_ApprovalDischargeMasterNew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Discharge Report Approval Right master</b>&nbsp;<br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server" Text=""></asp:Label>

        </div>
        <div style="width: 827px; text-align: center; padding-left: 75px;" class="border">
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="row">
                    <div class="col-md-5">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Search By Name 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-14">
                        <input id="Text1" onkeyup="SearchCheckbox(this,chkEmployee)" />
                    </div>
                    <div class="col-md-2">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Employee 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:CheckBox ID="chkAllEmployee" runat="server" Text="All" OnCheckedChanged="chkAllEmployee_CheckedChanged" AutoPostBack="true" />
                    </div>
                    <div class="col-md-19">
                        <div style="overflow: scroll; height: 500px; text-align: left; border: solid">
                            <asp:CheckBoxList ID="chkEmployee" runat="server" Height="16px" RepeatColumns="5" RepeatDirection="Horizontal" ClientIDMode="Static" CssClass="ItDoseCheckboxlist"></asp:CheckBoxList>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" />
            </div>
        </div>
    </div>
</asp:Content>

