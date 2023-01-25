<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="SurgeryBookingSearch.aspx.cs" Inherits="Design_OPD_SurgeryBookingSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript" >
       
    
    $(document).ready(function () {

        $('#<%=txtPreSurgeryDateFrom.ClientID %>').change(function () {
            ChkDate();

        });

        $('#<%=txtPreSurgeryDateTo.ClientID %>').change(function () {
            ChkDate();

        });

    });
    function ChkDate() {
        $.ajax({

            url: "../common/CommonService.asmx/CompareDate",
            data: '{DateFrom:"' + $('#txtPreSurgeryDateFrom').val() + '",DateTo:"' + $('#txtPreSurgeryDateTo').val() + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (data == false) {
                    $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                    $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    $('#<%=hide.ClientID %>').hide();

                }
                else {
                    $('#<%=lblMsg.ClientID %>').text('');
                    $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                }
            }
        });

    }

    function check(e) {
       
        var keynum
        var keychar
        var numcheck
        // For Internet Explorer  
        if (window.event) {
            keynum = e.keyCode
        }
        // For Netscape/Firefox/Opera  
        else if (e.which) {
            keynum = e.which
        }
        keychar = String.fromCharCode(keynum)
        var Pname = $('#<%=txtPname.ClientID %>').val();
        if (Pname.charAt(0) == ' ') {
            $('#<%=txtPname.ClientID %>').val('');
            $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
            return false;
        }
        //List of special characters you want to restrict
        if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
            
            return false;
        }

        else {
            return true;
        }
    }
    function validatespace() {
        var Pname = $('#<%=txtPname.ClientID %>').val();
        
        if (Pname.charAt(0) == ' ' || Pname.charAt(0) == '.' || Pname.charAt(0) == ',') {
           $('#<%=txtPname.ClientID %>').val('');
            $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
            Pname.replace(Pname.charAt(0), "");
            return false;
        }
        else {
            // $('#<%=lblMsg.ClientID %>').text('');
            return true;
        }

    }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>PreSurgery Booking List</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <table style="width:100%;border-collapse:collapse">
                <tr>
                    <td style="text-align: right; width: 232px">
                        PreSurgery ID :&nbsp;
                    </td>
                    <td style="text-align: left; width: 280px">
                        <asp:TextBox ID="txtBookingID" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbBookingID" runat="server" TargetControlID="txtBookingID"
                            FilterType="Numbers">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 160px; text-align: right">
                        UHID :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtPID" runat="server"></asp:TextBox>
                       
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 232px">
                        Patient Name :&nbsp;
                    </td>
                    <td style="text-align: left; width: 280px">
                        <asp:TextBox ID="txtPname" runat="server"  onkeypress="return check(event)"
                         ClientIDMode="Static" AutoCompleteType="Disabled" Width="250px"  onkeyup="validatespace();"></asp:TextBox>
                    </td>
                    <td style="width: 160px; text-align: right">
                        &nbsp;</td>
                    <td style="text-align: left">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 232px">
                        PreSurgery Date From :&nbsp;
                    </td>
                    <td style="text-align: left; width: 280px">
                        <asp:TextBox ID="txtPreSurgeryDateFrom" runat="server" ToolTip="Enter Date" Width="129px"
                            TabIndex="12" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calPreSurgeryDateFrom" runat="server" TargetControlID="txtPreSurgeryDateFrom"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 160px; text-align: right">
                        PreSurgery Date To :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtPreSurgeryDateTo" runat="server" ToolTip="Enter Date" Width="129px"
                            TabIndex="12" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calPreSurgeryDateTo" runat="server" TargetControlID="txtPreSurgeryDateTo"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 232px">
                        &nbsp;
                    </td>
                    <td style="text-align: left; width: 280px">
                        &nbsp;
                    </td>
                    <td style="width: 160px; text-align: right">
                        &nbsp;
                    </td>
                    <td style="text-align: left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center">
                        
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
                        <asp:Button ID="btnreport" runat="server" CssClass="ItDoseButton" 
                            Text="Report" onclick="btnreport_Click" />
            </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
        <div class="POuter_Box_Inventory" style="text-align:center">
            <div class="Purchaseheader">
                Result</div>
            <asp:Panel ID="hide" runat="server">
                 
                <asp:GridView ID="grdSurgery" runat="server" AutoGenerateColumns="False" 
                    CssClass="GridViewStyle" onrowcommand="grdSurgery_RowCommand" >
                   <AlternatingRowStyle CssClass="GridViewAltItemStyle" Width="1000px" />
                    <Columns>
                           <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="18px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                       
                        <asp:TemplateField HeaderText="UHID" HeaderStyle-Width="125px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="PName" HeaderText="Patient Name"  HeaderStyle-Width="220px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-HorizontalAlign="Left">
                          
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="PreSurgery&nbsp;ID"  HeaderStyle-Width="20px" ItemStyle-CssClass="GridViewItemStyle" Visible="false"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblPreSurgeryID" runat="server" Text='<%#Eval("PreSurgeryID")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="DiagnosisName" HeaderText="Diagnosis Name" HeaderStyle-Width="220px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-HorizontalAlign="Left">
                            
                        </asp:BoundField>
                         <%--<asp:BoundField DataField="PolicyNo"  HeaderText="Policy No." HeaderStyle-Width="220px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-HorizontalAlign="Left">
                           
                        </asp:BoundField>--%>
                        
                        <asp:BoundField DataField="ProcedureName" Visible="false" HeaderText="Procedure Name" HeaderStyle-Width="220px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-HorizontalAlign="Left">
                           
                        </asp:BoundField>
                        <asp:BoundField DataField="Date" HeaderText="Surgery Date" HeaderStyle-Width="220px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-HorizontalAlign="Left">
                           
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="View"  HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                               <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="APrint" ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("PreSurgeryID")%>' /> 
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit"  HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                               <asp:ImageButton ID="ibmEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/Images/edit.png" CommandArgument='<%# Eval("PreSurgeryID")%>' /> 
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cancel"  HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                               <asp:ImageButton ID="imbCancel" runat="server" CausesValidation="false" CommandName="ACancel" ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("PreSurgeryID")%>' /> 
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
           
            </asp:Panel>
        </div>
            </asp:Panel>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" Style="display:none" >
        <div class="Purchaseheader" id="Div1" runat="server">
            Cancel Bill</div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 476px">
                <tr>
                    <td style="width: 120px">
                        PreSurgery ID :
                    </td>
                    <td style="width: 395px">
                        <asp:Label ID="lblSurgeryID" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 120px">
                        Reason :
                    </td>
                    <td style="width: 395px">
                        <asp:TextBox ID="txtCancelReason" runat="server" CssClass="ItDoseTextinputText" Width="250px"
                            ValidationGroup="CancelBill" />&nbsp;<span style="color: Red; font-size: 9px;">*</span>
                            <cc1:FilteredTextBoxExtender ID="cfsreason" TargetControlID="txtCancelReason" FilterType="LowercaseLetters,UppercaseLetters" runat="server"></cc1:FilteredTextBoxExtender>
                        <asp:RequiredFieldValidator ID="rq1" runat="server" ControlToValidate="txtCancelReason"
                            ErrorMessage="Specify Cancel Reason" ValidationGroup="CancelBill" Text="*" Display="None" />
                            </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnReject" runat="server" CssClass="ItDoseButton" Text="Reject"
                ValidationGroup="CancelBill" OnClick="btnReject_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpCancel" runat="server" CancelControlID="btnCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlVendorItemsFilter" Style="display:none" >
        <div class="Purchaseheader" id="Div2" runat="server">
            Change Diagnosis Details</div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 476px">
                <tr>
                    <td colspan="2" >

                    </td>
                </tr>
                <tr>
                    <td style="width: 120px; text-align:right">
                        PreSurgery ID :
                    </td>
                    <td style="width: 395px">
                        <asp:Label ID="lblEditPreSurgeryID" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr  style="display:none">
                    <td style="width: 120px; text-align:right">
                        Procedure :&nbsp;
                    </td>
                    <td style="width: 395px">
                        <asp:TextBox ID="txtProcedure" TextMode="MultiLine" runat="server" CssClass="ItDoseTextinputText" Width="250px"
                            ValidationGroup="EditDetails" />&nbsp;<span style="color: Red; font-size: 9px;">*</span>
                      
                            </td>
                </tr>
                <tr>
                    <td style="width: 120px; text-align:right">
                        Diagnosis :&nbsp;
                    </td>
                    <td style="width: 395px">
                        <asp:TextBox ID="txtDiagnosis" ClientIDMode="Static" TextMode="MultiLine" runat="server" CssClass="ItDoseTextinputText" Width="250px"
                           />&nbsp;<span style="color: Red; font-size: 9px;">*</span>
                       
                            </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnEdit" runat="server" CssClass="ItDoseButton" Text="Update"
                 OnClick="btnEdit_Click" OnClientClick="return validateDia()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btncanceEdit" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpEdit" runat="server" CancelControlID="btncanceEdit"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel2" PopupDragHandleControlID="Div2">
    </cc1:ModalPopupExtender>
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false"
        ValidationGroup="CancelBill" />
        <asp:ValidationSummary ID="vs2" runat="server" ShowMessageBox="true" ShowSummary="false"
        ValidationGroup="EditDetails" />
    <script type="text/javascript">
        function validateDia() {
            if ($.trim($("#txtDiagnosis").val()) == "") {


                $("#txtDiagnosis").focus();
            }
        }
    </script>
</asp:Content>
