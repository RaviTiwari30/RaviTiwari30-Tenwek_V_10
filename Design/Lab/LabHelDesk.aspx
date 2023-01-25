<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="LabHelDesk.aspx.cs" Inherits="Design_Lab_LabHelDesk" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
        <script type="text/javascript" src="../../Scripts/jquery.tooltip.min.js"></script>
    <script type="text/javascript">
        function InitializeToolTip() {
            $(".gridViewToolTip").tooltip({
                track: true,
                delay: 0,
                showURL: false,
                fade: 100,
                bodyHandler: function () {
                    return $($(this).next().html());
                },
                showURL: false
            });
        }
    </script>
<script type="text/javascript">
    $(function () {
        InitializeToolTip();
    })
</script>
<style type="text/css">
    #tooltip {
	position: absolute;
	z-index: 3000;
	border: 1px solid #111;
	background-color: #FEE18D;
	padding: 5px;
	opacity: 0.85;
}
#tooltip h3, #tooltip div { margin: 0; }
</style>
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#FrmDate').change(function () {
                ChkDate();
            });
            $('#ToDate').change(function () {
                ChkDate();
            });
            show();
            $('#<%=rdbLabType.ClientID%>').change(function () {
                $('#grdhide').hide();
            });
            
        });


        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#grdhide').hide();
                        $('#<%=grdLabSearch.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
        function show() {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'OPD') {
                //  $("#<%=txtCRNo.ClientID %>").val('').prop('readOnly', 'true');
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();

            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'IPD') {
                //$("#<%=txtCRNo.ClientID %>").removeAttr('readOnly');
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
            }
        }
        $("#<%=rdbLabType.ClientID %> input:radio").change(function () {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'OPD') {
                $("#<%=grdLabSearch.ClientID %>").hide();
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'IPD') {
                $("#<%=grdLabSearch.ClientID %>").hide();
            }

        });
        
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
            
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <script type="text/javascript" >
         </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
              <b>  Lab Help Desk OPD</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
                <table  style="width: 100%;border-collapse:collapse">
                    <tr>
                        <td  style="width: 20%;text-align:right">
                            Type :&nbsp;
                        </td>
                        <td  colspan="3" style="width: 20%; text-align: center">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal"
                                Font-Bold="True" onclick="show();">                           
                                <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td  style="width: 20%;text-align:right">
                            UHID :&nbsp;
                        </td>
                        <td style="width: 30%;text-align:left">
                            <asp:TextBox ID="txtMRNo" runat="server" Width="144px" MaxLength="30" ToolTip="Enter UHID"
                                TabIndex="1" />
                        </td>
                        <td style="width: 20%;text-align:right">
                         <asp:Label ID="lblIPDNo" Text="IPD No. :&nbsp;" runat="server" style="display:none"></asp:Label>
                        </td>
                        <td  style="width: 30%;text-align:left">
                            <asp:TextBox ID="txtCRNo" runat="server" Width="144px" MaxLength="10" ToolTip="Enter IPD No."
                                TabIndex="2" style="display:none"/>
                                <cc1:FilteredTextBoxExtender ID="ftbtxtCRNo" TargetControlID="txtCRNo" FilterType="Numbers" runat="server"></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td  style="width: 20%;text-align:right">
                            Lab No. :&nbsp;
                        </td>
                        <td  style="width: 30%;text-align:left">
                            <asp:TextBox ID="txtLabNo" runat="server" Width="144px" MaxLength="10" ToolTip="Enter Lab No."
                                TabIndex="3" /> 
                                <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" TargetControlID="txtLabNo" FilterType="Numbers"
                                 runat="server"></cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 20%;text-align:right">
                            Patient Name :&nbsp;
                        </td>
                        <td style="width: 30%;text-align:left">
                            <asp:TextBox ID="txtPName" runat="server" Width="144px" MaxLength="30" ToolTip="Enter Name"
                                TabIndex="4" />
                        </td>
                    </tr>
                    <tr>
                        <td  style="width: 20%;text-align:right">
                           Doctor :&nbsp;
                        </td>
                        <td  style="width: 30%;text-align:left">
                         <asp:DropDownList ID="ddlDoctor" runat="server" Width="150px"></asp:DropDownList>  <asp:Label ID="lblDoctor" Visible="false" runat="server"></asp:Label></td>
                        <td  style="width: 20%;text-align:right">
                            Patient Test Type :&nbsp;
                        </td>
                        <td style="width: 30%;text-align:left">
                            <asp:DropDownList ID="ddlUrgent" runat="server" Width="150px" TabIndex="6" ToolTip="Select Patient Test Type">
                                <asp:ListItem Selected="True" Value="2">All</asp:ListItem>
                                <asp:ListItem Value="1">Urgent</asp:ListItem>
                                <asp:ListItem Value="0">Normal</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td  style="width: 20%;text-align:right">
                            From Date :&nbsp;
                        </td>
                        <td  style="width: 30%;text-align:left">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" Width="144px" TabIndex="7"
                                ToolTip="Select From Date" ></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </td>
                        <td  style="width: 20%;text-align:right">
                            To Date :&nbsp;
                        </td>
                        <td  style="width: 30%;text-align:left">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" Width="144px" TabIndex="8"
                                ToolTip="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                </table>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
                <br />
                <div id="colorindication" style="text-align: center">
                    <table style="width: 914px">
                        <tr style="text-align:center;"><asp:Label ID="lblPending" runat="server" ForeColor="Red" Text="Note: Pending Amount Patient View Button is not Show" Visible="false" ></asp:Label> </tr>
                        <tr>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="text-align: left; ">
                                Urgent
                            </td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: White;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="text-align: left;">
                                Test Prescribed
                            </td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:yellow;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                           <td style="text-align: left;">Sample Collected</td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:coral;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                           <td style="text-align: left;">Result Done</td>
                            <td style="width:15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                           <td style="text-align: left;">Approved</td>
                            
                            <td style="width:15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:Aqua;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                           <td style="text-align: left;">Outsource</td>
                             <td style="width:15px; border-right: black thin solid; border-top: black thin solid;display:none;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:red;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                           <td style="text-align: left;display:none;">Pending Amount</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div id="grdhide">
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" id="header">
                    Search Result
                </div>
                
                    <asp:GridView ID="grdLabSearch" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle grdLabResultSearch"
                        OnRowDataBound="grdLabSearch_RowDataBound" OnRowCommand="grdLabSearch_RowCommand" >
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="UHID">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                    <asp:Label ID="lblMRNo" Visible="false" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IPD&nbsp;No." Visible="false">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblTransNo" runat="server" Text='<%# Eval("TransNo") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Lab&nbsp;No.">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Font-Bold="True" Width="60px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblLedTnx" runat="server" Text='<%# Util.GetString(Eval("LedgerTransactionNo")).Replace("LISHHI","").Replace("LOSHHI","") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Patient Name">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="145px" />
                                <ItemTemplate>
                                <asp:Label ID="lbl_PName" runat="server" Text='<%#Eval("PName") %>'></asp:Label>
                                    <%--<%#Eval("PName") %>--%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="116px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="116px" />
                                <ItemTemplate>
                                <asp:Label ID="lbl_Age" runat="server" Text='<%#Eval("Age") %>'></asp:Label>
                                    <%--<%#Eval("Age") %>--%>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Gender">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="116px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="116px" />
                                <ItemTemplate>
                                <asp:Label ID="lbl_Gender" runat="server" Text='<%#Eval("Gender") %>'></asp:Label>
                                    <%--<%#Eval("Age") %>--%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Department">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                <ItemTemplate>
                                    <%#Eval("ObservationName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Investigation">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                <ItemTemplate>
                                    <%#Eval("Name") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date/Time">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="115px" />
                                <ItemTemplate>
                                    <%#Eval("InDate") + " " + Eval("Time")%>
                                    <asp:Label ID="lblResult" runat="server" Text=' <%#Eval("IsResult") %>' Visible="false"></asp:Label>
                                  
                                        <asp:Label ID="lblisApproved" runat="server" Text=' <%#Eval("isApproved") %>' Visible="false"></asp:Label>
                                  
                                  
                                    <asp:Label ID="lblIs_Urgent" runat="server" Text='<%#Eval("IsUrgent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIs_Outsource" runat="server" Text='<%#Eval("IsOutsource") %>' Visible="false"></asp:Label>
                                    <asp:TextBox ID="txtPrintout" Text="0" runat="server" Width="25px" MaxLength="2" Visible="false"></asp:TextBox>
                                    <asp:Label ID="lblTransactionID" runat="server" Text=' <%#Eval("TransactionID") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblInvestigation_Id" runat="server" Text=' <%#Eval("Investigation_Id") %>'
                                        Visible="false"></asp:Label>
                                     <asp:Label ID="lblTest_ID" runat="server" Text=' <%#Eval("Test_Id") %>'
                                        Visible="false"></asp:Label>
                                     <asp:Label ID="lbltype" runat="server" Text=' <%#Eval("Type") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblObservationType_Id" runat="server" Text=' <%#Eval("ObservationType_Id") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text=' <%#Eval("ID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblEntryType" runat="server" Text=' <%#Eval("EntryType") %>' Visible="false"></asp:Label>
                                      <asp:Label ID="lbl_samplecollect" runat="server" Text=' <%#Eval("IsSampleCollected") %>' Visible="false"></asp:Label>
                                      <asp:Label ID="lbl_AmountStatus" ClientIDMode="Static" runat="server" Text=' <%#Eval("AmountStatus") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblTestId" runat="server" Text=' <%#Eval("Test_Id") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblLedgerTnxID" runat="server" Text=' <%#Eval("LedgerTnxID") %>' Visible="false"></asp:Label>
                                     <asp:Label ID="lblLedTnx1" runat="server" Text='<%# Eval("LedgerTransactionNo1") %>' Visible="false"></asp:Label>
                                     <asp:Label ID="lblPrintedBy" runat="server" Text='<%#Eval("PrintedbyName") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                           <%-- <asp:TemplateField HeaderText="Select" Visible="false">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                <ItemTemplate>
                                  <asp:CheckBox ID="chkPrint" runat="server" Visible="false" />
                                    </ItemTemplate>
                            </asp:TemplateField>--%>
                           
                           
                            <asp:TemplateField HeaderText="View" Visible="false">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                <ItemTemplate>
                                     <asp:ImageButton ID="imbView" ToolTip="View Result" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("LedgerTransactionNo1")+"#"+Eval("TransactionID")+"#"+Eval("Type")%>' CommandName="viewResult" />
                                </ItemTemplate>
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="Status" Visible="false">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblPrintShow" runat="server"  style="display:none" >
                                    <a href="#" class="gridViewToolTip">
                                      <img src="../../Images/print.gif" alt="" />
                                    </a>
                               <div id="tooltip" style="display: none;">
                                    <table>
                                        <tr>
                                            <td style="white-space: nowrap;"><b>Printed By:</b>&nbsp;</td>
                                            <td><%# Eval("PrintedbyName")%></td>
                                        </tr>
                                        
                                    </table>
                                </div>   
                                        </asp:Label>      
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center">
          
                    <br />
                    </div>
            </div>
        </asp:Panel>
    </div></div>
    <asp:Panel ID="Panel1" runat="server" Style="display: none;" BackColor="#F3F7FA"
        BorderStyle="None">
        <div class="Outer_Box_Inventory" style="width: 393px">
            <div class="Purchaseheader" style="width: 380px">
                Patient Diagnosis Information</div>
            <table style="width: 385px">
                <tr>
                    <td  style="width: 30%;text-align:right" >
                        Patient Name :
                    </td>
                    <td  style="width: 70%;text-align:left" >
                        <asp:Label ID="lblName" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td  style="width: 30%;text-align:right" >
                        UHID :
                    </td>
                   <td  style="width: 70%;text-align:left" >
                        <asp:Label ID="lblCrNo" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td  style="width: 30%;text-align:right" >
                        Diagnosis :
                    </td>
                   <td  style="width: 70%;text-align:left" >
                        <asp:Literal ID="ltrDiagnosis" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%;text-align:right" >
                    </td>
                   <td  style="width: 70%;text-align:left" >
                    </td>
                </tr>
                <tr>
                    <td  colspan="2" style="text-align: center">
                        <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" Text="Close"></asp:Button>
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mdlPatient" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" PopupControlID="Panel1" TargetControlID="btnHidden"
        X="275" Y="200">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="pnlRemove" runat="server" Style="display: none;" BackColor="#F3F7FA"
        BorderStyle="None" Width="398px">
        <div class="Outer_Box_Inventory" style="width: 393px">
            <div class="content">
                <div style="text-align: center" id="Div2" class="Purchaseheader">
                    Test Removal Reason</div>
                <table style="width: 385px;border-collapse:collapse"  border="0">
                    <tr>
                        <td  style="width: 16%;text-align:right" >
                            Reason :
                        </td>
                        <td  style="width: 70%;text-align:left">
                            <asp:TextBox ID="txtReasonRemove" runat="server" Width="302px" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td  colspan="2" style="text-align: center" >
                            <asp:Button ID="btnCloseRemoval" runat="server" CssClass="ItDoseButton" Text="Close" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </asp:Panel>
     <cc1:ModalPopupExtender ID="mpePatientResult" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" PopupControlID="pnlPatientResult" TargetControlID="btnHidden" ClientIDMode="Static"
        X="275" Y="20">
    </cc1:ModalPopupExtender>
     <asp:Panel ID="pnlPatientResult" runat="server" Style="display: none; width: 830px; height: 350px;overflow-y:scroll" BackColor="#F3F7FA">
            <div>
                <div style="text-align:left" id="Div1" class="Purchaseheader">
                    Print Result &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePatientDetail()" onkeypress="onKeyDown();" />
                                to close</span></em></div>
                <table  border="0" style="width: 530px;border-collapse:collapse" >
                    <tr>
                             <asp:GridView ID="grdResult" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowDataBound="grdResult_RowDataBound"> 
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkall" runat="server"
                                                Checked="true" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" Checked="true" />
                                            <asp:Label ID="lblReportType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReportType") %>'
                                                Visible="False"></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="25px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField  HeaderText="Department" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDept" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Department") %>'></asp:Label>
                                        </ItemTemplate>
                                           <HeaderStyle Width="250px" />
                                    </asp:TemplateField>
                                  
                                    <asp:BoundField DataField="Name" HeaderText="Investigations" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle Width="350px" HorizontalAlign="Left"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Date" HeaderText="Date" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle Width="100px" HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Print" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandName="imbPrint"
                                                CommandArgument='<%# Eval("Test_ID")+"$"+Eval("ReportType") %>' ImageUrl="~/Images/print.gif" Style="display: none;" />

                                            <a target="_blank" href='../../Design/Lab/printLabReport.aspx?TestID=<%# Eval("Test_ID") %>'>
                                                <asp:Image ID="imbPrinta" runat="server" ImageUrl="~/Images/print.gif" Style="border: none;" /></a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                        HeaderText="Approve" >
                                        <ItemTemplate>
                                            <asp:Label ID="lblApprove" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Approved") %>'> </asp:Label>
                                            <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'
                                                Visible="False"> </asp:Label>
                                            <asp:Label ID="lbldhk" runat="server" Visible="false" Text='<%# Eval("Approved") %>'></asp:Label>
                                            <asp:TextBox ID="txtTest_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Test_ID") %>'
                                                Style="display: none"> </asp:TextBox>
                                            <asp:Label ID="lblDepartment" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Department") %>'
                                                Visible="False"> </asp:Label>
                                              <%--   <asp:Label ID="lblPenAmount" runat="server" Text='<%# Eval("AmountStatus") %>'
                                                Visible="False">
                                            </asp:Label>--%>
                                             
                                        </ItemTemplate>
                                        <HeaderStyle Width="100px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView> 
                    </tr>
                </table>
                <div style="text-align:center">
                    <asp:Label ID="lblUpdateLedgertransactionNo" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lbllabType" runat="server" Visible="false"></asp:Label>
                      <asp:Button ID="btnPrint" runat="server" CssClass="ItDoseButton" Text="Print" OnClick="btnPrint_Click"  Visible="false" />
                </div>
            </div>
       
    </asp:Panel>
    <script type="text/javascript">
        $("#<%=grdResult.ClientID%> input[id*='chkSelect']:checkbox").click(function () {
            var totalCheckboxes = $("#<%=grdResult.ClientID%> input[id*='chkSelect']:checkbox").size();
              var checkedCheckboxes = $("#<%=grdResult.ClientID%> input[id*='chkSelect']:checkbox:checked").size();
              $("#<%=grdResult.ClientID%> input[id*='chkall']:checkbox").attr('checked', totalCheckboxes == checkedCheckboxes);
          });

          $("#<%=grdResult.ClientID%> input[id*='chkall']:checkbox").click(function () {
            $("#<%=grdResult.ClientID%> input[id*='chkSelect']:checkbox").attr('checked', $(this).is(':checked'));
            });
        function closePatientDetail() {
            $find("mpePatientResult").hide();
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpePatientResult')) {
                    $find('mpePatientResult').hide();
                }
            }
        }
    </script>
    </asp:Content>
