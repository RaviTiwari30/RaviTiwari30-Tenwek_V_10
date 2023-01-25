<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="LabWorkSheet.aspx.cs" Inherits="Design_Lab_LabWorkSheet" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
 <script type="text/javascript">


     function chkAll(rowID) {
         if ($(rowID).is(':checked'))
             $(".allChecked input[type='checkbox']").attr('checked', 'checked');
         else
             $(".allChecked input[type='checkbox']").attr('checked', false);
     }
     function chkAllPrint(rowID) {
         if ($(rowID).is(':checked'))
             $(".allPrintChecked input[type='checkbox']").attr('checked', 'checked');
         else
             $(".allPrintChecked input[type='checkbox']").attr('checked', false);
     }

     

    </script>
    <script type="text/javascript">
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
                        $('#<%=btnSearch.ClientID %>,#<%=btnWorkSheet.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdLabSearch.ClientID %>').hide();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>,#<%=btnWorkSheet.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>

    <script type="text/javascript">

        $(document).ready(function () {
            blockUIOnRequest();
            $('#ddlDepartment,#ddlPanel').chosen({ width: '100%' });
            $('#txtBarCodeNo').focus();
        });


        var blockUIOnRequest = function () {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $modelBlockUI();
            });
            prm.add_endRequest(function () {
                $modelUnBlockUI();
                MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                $('#dvgv').customFixedHeader();
            });
        }

         </script>
    <script type="text/javascript">
        function validatespace() {
            var card = $('#<%=txtPName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtPName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                // $('#<%=lblMsg.ClientID %>').text('');
                return true;
            }

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
            var card = $('#<%=txtPName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtPName.ClientID %>').val('');
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
        $(document).ready(function () {
            show();
        });
        function show() {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'OPD') {
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();
                $("#<%=lblipdcln.ClientID %>").hide();

            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'IPD' || $('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'ALL') {
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
                $("#<%=lblipdcln.ClientID %>").show();

            }
        }
        $("#<%=rdbLabType.ClientID %> input:radio").change(function () {
            $('#<%=lblMsg.ClientID %>').text('');
            if ($('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'OPD' || $('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'ALL') {
                $('#<%=grdLabSearch.ClientID %>').hide();
            }
            if ($('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'IPD') {
                $('#<%=grdLabSearch.ClientID %>').hide();
            }
        });

        $(document).ready(function () {

            $('#<%=rdbLabType.ClientID%>').change(function () {
                $('#<%=lblMsg.ClientID %>').text('');
                $('#dvgv').hide();
            });
        });
        function FirePageLevelOkButton() {
            var okButton = document.getElementById('<%=btnSearch.ClientID %>');
            if (okButton) {
                okButton.click(); // if you have ok button in page you can fire click, 
                //this will execute codebehind code
            }
        }

        </script>
    
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Investigation Work Sheet</b>
            <br />
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal"
                                onclick="show();">
                                <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="All" Value="ALL"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblIPDNo" Text="IPD No." runat="server" Style="display: none"></asp:Label>
                            </label>
                            <b id="lblipdcln" style="display: none;" runat="server" class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCRNo" runat="server" MaxLength="10" ToolTip="Enter IPD No."
                                TabIndex="2" Style="display: none" />
                            <cc1:FilteredTextBoxExtender ID="ftbtxtCRNo" runat="server" TargetControlID="txtCRNo"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" TabIndex="1" ToolTip="Enter MR No."
                                MaxLength="20" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Lab No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLabNo" runat="server" MaxLength="20" TabIndex="3"
                                ToolTip="Enter Diagnosis No." />
                            <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" runat="server" TargetControlID="txtLabNo"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <b>Bar Code No.</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBarCodeNo" runat="server" autocomplete="off" MaxLength="10" ClientIDMode="Static" onkeyup="if(event.keyCode==13){$('#btnSearch').click();};"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient&nbsp;Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPName" runat="server" TabIndex="4" ToolTip="Enter Patient Name"
                                onkeypress="return check(event)" onkeyup="validatespace();" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Test Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUrgent" runat="server" TabIndex="5" ToolTip="Select Patient Test Type">
                                <asp:ListItem Selected="True" Value="2">All</asp:ListItem>
                                <asp:ListItem Value="1">Urgent</asp:ListItem>
                                <asp:ListItem Value="0">Normal</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                CPT Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCptcode" runat="server" MaxLength="20" TabIndex="6"
                                ToolTip="Enter CPT Code" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="7" ClientIDMode="Static" ToolTip="Select Department">
                            </asp:DropDownList>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server" TabIndex="8" ToolTip="Select Status">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem>Not Approved</asp:ListItem>
                                <asp:ListItem Selected="True">Result Not Done</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" ClientIDMode="Static" TabIndex="9" ToolTip="Select Panel">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" TabIndex="11" ToolTip="Select From Date" onchange="ChkDate();"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtFromTime" runat="server" Style="display: none"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtFrom" Mask="99:99:99" TargetControlID="txtFromTime"
                                AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtFrom" ControlExtender="mee_txtFrom"
                                ControlToValidate="txtFromTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" TabIndex="12" onchange="ChkDate();"
                                ToolTip="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtToTime" runat="server" Style="display: none"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtTo" Mask="99:99:99" TargetControlID="txtToTime"
                                AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtTo" ControlExtender="mee_txtTo"
                                ControlToValidate="txtToTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Print Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPrintStatus" runat="server" ClientIDMode="Static">
                                <asp:ListItem Text="Pending" Value="0" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Printed" Value="1"></asp:ListItem>
                                <asp:ListItem Text="All" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                            </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-10"></div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click"
                                OnClientClick="javascript:FirePageLevelOkButton();" TabIndex="11" ClientIDMode="Static" ToolTip="Click To Search" style="width:100px;" />
                        </div>
                       
                        <div class="col-md-3">
                            <asp:Button ID="btnWorkSheet" runat="server" CssClass="ItDoseButton" Text="Worksheet"
                               ToolTip="Click To Open Worksheet"  style="width:100px;" OnClick="btnWorkSheet_Click" />
                        </div>

                        <div class="col-md-8"></div>
                    </div>
                    <div class="row"></div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div><div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellowgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Mac</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: darkgray;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left;">Due Amount</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90EE90;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Approved</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: coral;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Not Approved</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: White;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Not Done</b>
                        </div>
                        <div class="col-md-2">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Urgent</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: Aqua;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Outsource</b>
                        </div>
                        <div class="col-md-1 circle" style="width: 40px; height: 29px; margin-left: 5px; background-color: white;">
                            <img alt="" style="margin-top: -20px;" src="../../Images/tatdelay.gif" />
                        </div>
                        <div class="col-md-2">
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Delay</b>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="POuter_Box_Inventory" style="text-align: center; overflow:auto;max-height:315px" id="dvgv">
                    <asp:GridView ID="grdLabSearch" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%"
                        OnRowDataBound="grdLabSearch_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                    <asp:Image runat="server" ID="imgDelay" ImageUrl="~/Images/tatdelay.gif" Visible="false" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientType" runat="server" Text='<%# Util.GetString( Eval("Type")) %>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                           
                             <asp:TemplateField HeaderText="MR No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID"  runat="server" Text='<%# Util.GetString( Eval("PID")) %>'></asp:Label>
                                    <span class="patientID" style="display:none"><%# Util.GetString( Eval("PID")) %></span>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            
                            <asp:TemplateField Visible="false" HeaderText="Packs No.">
                                <ItemTemplate>
                                    <%# Util.GetString(Eval("Test_ID"))%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Bar Code No.">
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="105px"  />
                                <ItemTemplate>
                                    <asp:Label ID="lblBarCodeNo" runat="server" Text='<%#Eval("BarCodeNo") %>' CssClass="BarCodeNo" Font-Bold="true"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>    
                            <asp:TemplateField HeaderText="IPD No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblIPDNo" runat="server" Text='<%# Util.GetString(Eval("TransactionID")).Replace("LLSHHI","").Replace("LSHHI","").Replace("LISHHI","").Replace("ISHHI","")%>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Room" Visible="false">
                                <ItemTemplate>
                                    <%# Util.GetString(Eval("room"))%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Lab No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblLedTnx" runat="server" Text='<%# Util.GetString( Eval("LedgerTransactionNo")).Replace("LOSHHI","").Replace("LISHHI","") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="LedgerTransactionNo" CssClass="labNo" runat="server" Text='<%# Util.GetString( Eval("LTD")) %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText=" Name">
                                <ItemTemplate>
                                     <asp:Label   class="customTooltip "   data-title='<%#Eval("PName") %>' ID="lblPName" Style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" runat="server" Text='<%# Eval("PName") %>'></asp:Label>
                                     <span class="patientName" style="display:none"><%#Eval("PName") %></span>
                                     <span id="spnPatientID" style="display: none"><%# Util.GetString(Eval("PID"))%></span>
                                     <span id="spnTestID" style="display: none"><%# Util.GetString(Eval("Test_ID"))%></span>
                                     <span id="spnPatientType" style="display: none"><%# Util.GetString( Eval("Type")) %></span>
                                    
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="195px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age">
                                <ItemTemplate>
                                    <asp:Label ID="lblAge"  runat="server" Text='<%# Eval("Age") %>'></asp:Label>
                                    <span class="age"  style="display:none"><%# Eval("Age") %></span>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Investigation">
                                <ItemTemplate>
                                    <div  class="customTooltip Investigation"   data-title='<%#Eval("Name") %>' style="text-align: center; max-width: 180px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        <%#Eval("Name") %>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <%#Eval("InDate") + " " + Eval("Time")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Doctor">
                                <ItemTemplate>
                                    <div  class="customTooltip doctorName"   data-title='<%#Eval("Dname") %>' style="text-align: center; max-width: 105px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        <%#Eval("Dname") %>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Panel">
                                <ItemTemplate>
                                    <div class="customTooltip panel"   data-title='<%#Eval("Panel") %>' style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;">
                                        <%#Eval("Panel") %>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                           
                            <asp:TemplateField HeaderText="Print" Visible="false" HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-CssClass="GridViewLabItemStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblResult" runat="server" Text=' <%#Eval("IsResult") %>' Visible="false" />
                                    <asp:Label ID="lblapprove" runat="server" Text=' <%#Eval("Approved") %>' Visible="false" />
                                    <asp:Label ID="lblPendingAmount" runat="server" Text=' <%#Eval("PendingAmount") %>' Visible="false" />
                                    <asp:Label ID="lblMacStatus" runat="server" Text=' <%#Eval("MacStatus") %>' Visible="false" />
                                    <asp:Label ID="lblReportType" runat="server" Text=' <%#Eval("ReportType") %>' Visible="false" />
                                    <asp:ImageButton ID="imbPrint" runat="server" Visible="false" CausesValidation="false"
                                        CommandName="Print" ImageUrl="~/Images/print.gif" CommandArgument='<%#Eval("LedgerTransactionNo") +"#"+Eval("Test_ID") + "#" + Eval("PatientID")+"#"+Eval("ReportType")%> ' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkSelectAll" runat="server" Style="float: right; padding-right: 5px;"
                                        ClientIDMode="Static" onclick="chkAll(this)" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkPrintWorksheet" Visible='<%# !Util.GetBoolean(Eval("chkWork"))%>'
                                        runat="server" Style="float: right; padding-right: 5px;" CssClass="allChecked" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View" Visible="false">
                                <ItemTemplate>
                                    <img src="../../Images/view.GIF" onclick="showRemarks(this)" style="cursor: pointer" title="Doctor Remark" />
                                    <asp:Label ID="lblLedgerTnx" ClientIDMode="Static" runat="server" Text='<%# Util.GetString( Eval("LedgerTransactionNo")) %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblInvestigation_Id" ClientIDMode="Static" runat="server" Text=' <%#Eval("Investigation_ID") %>' Style="display: none" />
                                    <asp:Label ID="lblType" ClientIDMode="Static" runat="server" Text=' <%#Eval("Type") %>' Style="display: none" />
                                    <asp:Label ID="lblTestID" ClientIDMode="Static" runat="server" Text=' <%#Eval("Test_ID") %>' Style="display: none" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="No of Printout" Visible="false">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtPrintout" Text="0" runat="server" Width="25px"></asp:TextBox>
                                    <%-- <asp:Label ID="lblTransactionID" runat="server" Text=' <%#Eval("Transaction_ID") %>' Visible="false"></asp:Label>--%>
                                    <cc1:FilteredTextBoxExtender ID="Return" runat="server" FilterMode="ValidChars" FilterType="Custom,Numbers"
                                        TargetControlID="txtPrintout">
                                    </cc1:FilteredTextBoxExtender>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TestType" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblUrgent" runat="server" Text='<%#Eval("IsUrgent") %>' Font-Bold="true"></asp:Label>
                                    <asp:Label ID="lblIs_Outsource" runat="server" Text='<%#Eval("IsOutsource") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsDelay" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsDelay" runat="server" Text='<%# Util.GetString( Eval("IsDelay")) %>'></asp:Label>
                                    <asp:Label ID="lblIsPrint" runat="server" Text='<%# Util.GetString( Eval("isPrint")) %>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField Visible="false">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkHeaderPrintAll" runat="server" Style="float: right; padding-right: 5px;"
                                        onclick="chkAllPrint(this)" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkPrint" Visible='<%# Util.GetBoolean(Eval("chkWork"))%>'
                                        runat="server" Style="float: right; padding-right: 5px;" CssClass="allPrintChecked" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                                                
                        </Columns>
                    </asp:GridView>
                </div>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="grdLabSearch" />
                <asp:AsyncPostBackTrigger ControlID="btnSearch" />

            </Triggers>
        </asp:UpdatePanel>
    </div>

</asp:Content>

