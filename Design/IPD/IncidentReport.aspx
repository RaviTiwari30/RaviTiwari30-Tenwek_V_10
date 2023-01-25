<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IncidentReport.aspx.cs" Inherits="Design_IPD_IncidentReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <style type="text/css">input[type="text"], select {width:170px;}</style>
    <script  src="../../Scripts/ScrollableGridPlugin.js" type="text/javascript"></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#<%=grdSurgery.ClientID %>').Scrollable({

            });
        });
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
            <b>Incident Report</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <table style="width:100%">
                <tr>
                    <td style="text-align: right; width: 20%">
                        Incident Form ID :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtBookingID" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbBookingID" runat="server" TargetControlID="txtBookingID"
                            FilterType="Numbers">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 20%; text-align: right">
                        UHID :&nbsp;
                    </td>
                    <td style="text-align: left;width:30%">
                        <asp:TextBox ID="txtPID" runat="server"></asp:TextBox>
                       
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">
                        IPD No. :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtPname" runat="server"  onkeypress="return check(event)"
                         CssClass="ItDoseTextinputText"  ClientIDMode="Static" AutoCompleteType="Disabled" onkeyup="validatespace();"></asp:TextBox>
                    </td>
                    <td style="width: 20%; text-align: right">
                        &nbsp;</td>
                    <td style="text-align: left">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">
                        Incident Date From :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtPreSurgeryDateFrom" runat="server" ToolTip="Enter Date"
                            TabIndex="12" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calPreSurgeryDateFrom" runat="server" TargetControlID="txtPreSurgeryDateFrom"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">
                        Incident Date To :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtPreSurgeryDateTo" runat="server" ToolTip="Enter Date" 
                            TabIndex="12" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calPreSurgeryDateTo" runat="server" TargetControlID="txtPreSurgeryDateTo"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <div class="Purchaseheader">
                Result</div>
            <asp:Panel ID="hide" runat="server">
                 
                <asp:GridView ID="grdSurgery" runat="server" AutoGenerateColumns="False" 
                    CssClass="GridViewStyle" OnRowCommand="grdSurgery_RowCommand" >
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
                        <asp:TemplateField HeaderText="IPD No." HeaderStyle-Width="125px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            
                            <ItemTemplate>
                                <asp:Label ID="lblIPDNo" runat="server" Text='<%#Eval("TransactionID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Incident&nbsp;Report&nbsp;Form&nbsp;ID"  HeaderStyle-Width="20px" ItemStyle-CssClass="GridViewItemStyle" 
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblIncidentReportID" runat="server" Text='<%#Eval("IncidentReportID")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="PreSurgery&nbsp;ID"  HeaderStyle-Width="20px" ItemStyle-CssClass="GridViewItemStyle" 
                                HeaderStyle-CssClass="GridViewHeaderStyle">    
                        <ItemTemplate>
                                <asp:Label ID="lblIncidentReportDate" runat="server" Text='<%#Eval("IncidentReportDate")%>'></asp:Label>
                            </ItemTemplate>
                              </asp:TemplateField>
                        <asp:TemplateField HeaderText="View"  HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                               <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="APrint" ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("ID")+"#"+Eval("TransactionID")%>' /> 
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
           
            </asp:Panel>
        </div>
    </div>
    
</asp:Content>
