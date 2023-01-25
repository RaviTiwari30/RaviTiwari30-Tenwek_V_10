<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CopyRates.aspx.cs" Inherits="Design_EDP_CopyRates"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            document.getElementById("Pbody_box_inventory").style.display = 'none';
        }

        function chkSelectAllOPD(fld) {
            var gridTable = document.getElementById('<%=grdEditOPD.ClientID %>');
            var chkList = gridTable.document.getElementsByTagName("input:checkbox");
            for (var i = 0; i < chkList.length; i++) {
                if (chkList[i].type == "checkbox") {
                    chkList[i].checked = fld.checked;
                }
            }
        }
        function chkSelectAllIPD(fld) {
            var gridTable = document.getElementById('<%=grdEditIPD.ClientID %>');
            var chkList = gridTable.document.getElementsByTagName("input");
            for (var i = 0; i < chkList.length; i++) {
                if (chkList[i].type == "checkbox") {
                    chkList[i].checked = fld.checked;
                }
            }
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function CheckPercentage(Percentage) {
            var Per = $(Percentage).val();
            if (Per.match(/[^0-9\.]/g)) {
                Per = Amt.replace(/[^0-9\.]/g, '');
                $(Percentage).val(Number(Per));
                return;
            }
            if (Per.charAt(0) == "0") {
                $(Percentage).val(Number(Per));
            }


            if (Per.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = Per.indexOf(".");
                if (valIndex > "0") {
                    if (Per.length - (Per.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(Percentage).val($(Percentage).val().substring(0, ($(Percentage).val().length - 1)));
                        return false;
                    }
                }
            }

            if (parseFloat($(Percentage).val()) > 100) {
                alert('Percentage cannot greater than 100');
                $(Percentage).val($(Percentage).val().substring(0, ($(Percentage).val().length - 1)));

            }
            if (Per == "") {
                $(Percentage).val('0');

            }



        }

        function validate() {

            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave');


        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Copy Schedule of Charges<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Operation
            </div>
            <div style="text-align: center">
                <asp:Button ID="btncreateRateOPD" runat="server" CssClass="ItDoseButton" Text="Create/Copy Rate for OPD"
                    OnClick="btncreateRateOPD_Click" />
                <asp:Button ID="btncreateRateIPD" runat="server" CssClass="ItDoseButton" Text="Create/Copy Rate for IPD"
                    OnClick="btncreateRateIPD_Click" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Copy Rates
            </div>
            <div id="SchData" style="text-align: center">
                <div id="AddNew">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        <asp:Label ID="lblPanel" runat="server" Text="Panel :" Visible="False"></asp:Label>
                                    </label>
                                    
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlPanel" runat="server"  Visible="False" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged">
                                </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        <asp:Label ID="LblCpyFrm" runat="server" Text="Copy From :" Visible="False"></asp:Label>
                                    </label>
                                    
                                </div>
                                <div class="col-md-5">
                                     <asp:DropDownList ID="ddlCpyFrm" runat="server" Visible="False">
                                </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        <asp:Label ID="LblCpyTo" runat="server" Text="Copy To :" Visible="False"></asp:Label>
                                    </label>
                                    
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlCpyTo" runat="server"  Visible="False">
                                </asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                               <div class="col-md-3">
                                   
                                    
                                </div>
                                <div class="col-md-5">
                                    
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        <asp:Label ID="lblCopyCentreFrom" runat="server" Text="Copy From Centre:" Visible="False"></asp:Label>
                                    </label>
                                    
                                </div>
                                <div class="col-md-5">
                                     <asp:DropDownList ID="ddlCentreCopyFrom" runat="server" Visible="False">
                                </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        <asp:Label ID="lblCentreCopyto" runat="server" Text="Copy To Centre:" Visible="False"></asp:Label>
                                    </label>
                                    
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlCentreCopyto" runat="server"  Visible="False">
                                </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Set Rates
            </div>
            <div id="AddNewCharge"  style="text-align: center;">
                <asp:GridView ID="grdEditOPD" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    Visible="false" Width="100%">
                    <Columns>
                        <asp:BoundField DataField="DisplayName" HeaderText="SubCategory Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="OPD %">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlPlus" runat="server" Width="50px">
                                    <asp:ListItem>+</asp:ListItem>
                                    <asp:ListItem>-</asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox ID="txtOpdRate" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="CheckPercentage(this);" runat="server" Width="37px" Text="0" MaxLength="5"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbOpdRate" ValidChars=".0987654321" runat="server" TargetControlID="txtOpdRate"></cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Select">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkSelectAll" runat="server" onclick="chkSelectAllOPD(this);" Style="float: right; padding-right: 5px;"
                                    Text="SelectAll" TextAlign="Left" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelectOne" runat="server" Style="float: right; padding-right: 3px;" />
                                <asp:Label ID="Cname" runat="server" Visible="False" Text='<%#Eval("DisplayName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <HeaderStyle HorizontalAlign="Left" />
                </asp:GridView>
                <asp:GridView ID="grdEditIPD" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    Visible="false" Width="100%">
                    <Columns>
                        <asp:BoundField DataField="DisplayName" HeaderText="SubCategory Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="IPD %">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlPlus2" runat="server" Width="50px">
                                    <asp:ListItem>+</asp:ListItem>
                                    <asp:ListItem>-</asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox ID="txtIpdRate" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="CheckPercentage(this);" MaxLength="5" runat="server" Width="37px" Text="0"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbIpdRate" ValidChars=".0987654321" runat="server" TargetControlID="txtIpdRate"></cc1:FilteredTextBoxExtender>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Select">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkSelectAll" runat="server" onclick="chkSelectAllIPD(this);" Style="float: right; padding-right: 5px;"
                                    TextAlign="Left" Text="SelectAll" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelectOne" runat="server" Style="float: right; padding-right: 5px;" />
                                <asp:Label ID="Cnameipd" runat="server" Visible="False" Text='<%#Eval("DisplayName")%>'></asp:Label>
                                <asp:Label ID="lblConfigID" runat="server" Text='<%#Eval("ConfigID") %>' Visible="false"></asp:Label>

                            </ItemTemplate>

                        </asp:TemplateField>

                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <HeaderStyle HorizontalAlign="Left" />
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save"
                OnClick="btnSave_Click" Visible="false" OnClientClick="return validate()" />

        </div>
    </div>
</asp:Content>
