<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RadiologyPhysicalAcceptance.aspx.cs" Inherits="Design_Lab_RadiologyPhysicalAcceptance"
 ValidateRequest="false"  MasterPageFile="~/DefaultHome.master"
    MaintainScrollPositionOnPostback="true" 
     %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" >

        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();

            });

            $('#ToDate').change(function () {
                ChkDate();

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
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }

        function WriteToFile(data, name) {
            try {
                var fso = new ActiveXObject("Scripting.FileSystemObject");
                var s = fso.CreateTextFile("C:\\BarCode\\" + name + ".txt", true);
                s.WriteLine(data);
                s.Close();
            }
            catch (e) { }
        }

        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            var key;

            if (window.event)
                key = e.keyCode;
            // key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 80 || key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);

                if (btn != null) { //If we find the button click it
                    btn.click();
                    //event.keyCode = 0
                }
            }
        }
        $(document).ready(function () {
            show();
        });
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
                $("#<%=grdLabSearch2.ClientID %>").hide();
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'IPD') {
                $("#<%=grdLabSearch2.ClientID %>").hide();
            }

        });

        $(document).ready(function () {

            $('#<%=rdbLabType.ClientID%>').change(function () {
                $('#grdhide').hide();
            });
        });

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
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Radiology Acceptance</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <table cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td align="left" colspan="4" style="width: 20%; text-align: center">
                            
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">
                            UHID :&nbsp;
                        </td>
                        <td align="left" style="width: 30%">
                            <asp:TextBox ID="txtMRNo" runat="server" MaxLength="20" Width="125px"></asp:TextBox>
                        </td>
                        <td align="right" style="width: 20%">
                    <asp:Label ID="lblIPDNo" Text="IPD No. :&nbsp;" runat="server" style="display:none"></asp:Label>
                        </td>
                        <td align="left" style="width: 30%">
                            <asp:TextBox ID="txtCRNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="15" Width="125px"  style="display:none"/>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtCRNo" TargetControlID="txtCRNo" FilterType="Numbers" runat="server"></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">
                            Patient Name :&nbsp;
                        </td>
                        <td align="left" style="width: 30%">
                            <asp:TextBox ID="txtPName" runat="server" MaxLength="30" CssClass="ItDoseTextinputText" Width="125px"  onkeypress="return check(event)" onkeyup="validatespace();"/>
                        </td>
                        <td align="right" style="width: 20%">
                            Type :&nbsp;</td>
                        <td align="left" style="width: 30%">
                         
                            <asp:RadioButtonList ID="rdbLabType" runat="server" 
                                CssClass="ItDoseRadiobuttonlist" Font-Bold="True" Font-Size="Small" 
                                RepeatDirection="Horizontal" onclick="show();">
                                <asp:ListItem Selected="True" Text="OPD" Value="OPD"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                            </asp:RadioButtonList></td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%;">
                           <%-- Bar Code :&nbsp;--%>                 <%--<asp:TextBox ID="txtBarcode" runat="server"></asp:TextBox>--%>
                            &nbsp;From Date :&nbsp;</td>
                        <td align="left" style="width: 30%;">
              <%--<uc1:EntryDate ID="FrmDate" runat="server" />--%>
                          <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" Width="125px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender></td>
                        <td align="right" style="width: 20%; ">
                            
                            To Date :&nbsp;</td>
                        <td align="left" style="width: 30%;">
                                     <%--<uc1:EntryDate ID="ToDate" runat="server" />--%>
                         <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" Width="125px"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                        &nbsp;
                         
                            <asp:TextBox ID="txtLabNo" runat="server" CssClass="ItDoseTextinputText" Width="36px"
                              Visible="false" />
                                </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">
                           
                        </td>
                        <td align="left" style="width: 30%">
                         
                          
                        </td>
                        <td align="right" style="width: 20%">
                           
                        </td>
                        <td align="left" style="width: 30%">
                   
                           
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Width="87px" Text="Search"
                    OnClick="btnSearch_Click" />
            </div>
           <div id="colorindication" runat="server">
                    <table style="width: 690px">
                        <tr><td style="width: 180px"></td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:tan;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                                Physically Done
                            </td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:White;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                                Physically Not Done
                            </td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                                Urgent
                            </td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:Teal;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                               Outsource
                            </td>
                          
                        </tr>
                    </table>
                </div>
        </div>
        <div id="grdhide">
         <asp:Panel ID="pnlHide" runat="server" Visible="false">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div>
                <asp:GridView ID="grdLabSearch2" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowDataBound="grdLabSearch_RowDataBound" Width="970px">
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
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No." Visible="false">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                            <ItemTemplate>
                           
                                <asp:Label ID="lblTransactionID" runat="server" Text='<%#Util.GetString(Eval("TransactionID")).Replace("ISHHI","").Replace("LLSHHI","") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Lab No." Visible="false">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Font-Bold="True" Width="90px" />
                            <ItemTemplate>
                                <asp:Label ID="lblLedTnx" runat="server" Text='<%#Eval("LedgerTransactionNo") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="145px" />
                            <ItemTemplate>
                            <asp:Label ID="lbl_pname" runat="server" Text=<%#Eval("PName") %>></asp:Label>
                        
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Age">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                            <asp:Label ID="lbl_age" runat="server" Text=  <%#Eval("Age") %>></asp:Label>           
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Department" Visible="false">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
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
                            <asp:TemplateField HeaderText="Additional Views">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemTemplate>
                                <%#Eval("Remarks") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="115px" />
                            <ItemTemplate>
                                <%#Eval("InDate") + " " + Eval("Time")%>
                              
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:Label ID="lblheader" runat="server" Text="Select Test"></asp:Label>
                            </HeaderTemplate>
                            <%-- HeaderText="Sample Collect">--%>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="chkPhysicalAcceptance" runat="server" />
                                <asp:Label Text='<%#Eval("physical_acceptance") %>' ID="lblphysical" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblIs_Urgent" runat="server" Text='<%#Eval("IsUrgent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIs_Outsource" runat="server" Text='<%#Eval("IsOutsource") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField Visible="false">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtPrintout" Text="0" runat="server" Width="25px"></asp:TextBox>
                                <asp:Label ID="lblTransactionID" runat="server" Text=' <%#Eval("TransactionID") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblInvestigation_Id" runat="server" Text=' <%#Eval("Investigation_Id") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblObservationType_Id" runat="server" Text=' <%#Eval("ObservationType_Id") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblID" runat="server" Text=' <%#Eval("ID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblEntryType" runat="server" Text=' <%#Eval("EntryType") %>' ></asp:Label>
                                <asp:Label ID="lblTestId" runat="server" Text=' <%#Eval("Test_Id") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblLedgerTnxID" runat="server" Text=' <%#Eval("LedgerTnxID") %>' Visible="false"></asp:Label>
                                <cc1:FilteredTextBoxExtender ID="Return" runat="server" FilterMode="ValidChars" FilterType="Custom,Numbers"
                                    TargetControlID="txtPrintout">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                &nbsp;<br />
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                    Text="Save"  />&nbsp;
                <asp:Button ID="btnRemoveTest" runat="server" CssClass="ItDoseButton" Text="Remove Test"
                     Visible="false" /></div>
        </div>
                </asp:Panel>
    </div></div>
    &nbsp;<div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="pnlRemove" runat="server" Style="display: none;" BackColor="#F3F7FA"
        BorderStyle="None" Width="398px">
        <div class="Outer_Box_Inventory" style="width: 393px">
            <div class="content">
                <div style="text-align: center" id="Div2" class="Purchaseheader">
                    Test Removal Reason</div>
                <table style="width: 385px" cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td align="left" style="width: 16%" valign="middle">
                            Reason :
                        </td>
                        <td valign="middle" align="left" style="width: 70%">
                            <asp:TextBox ID="txtReasonRemove" runat="server" Width="302px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2" style="text-align: center" valign="middle">
                            
                            
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeRemove" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnCloseRemoval" PopupControlID="pnlRemove" TargetControlID="btnRemoveTest"
        X="275" Y="200">
    </cc1:ModalPopupExtender>
</asp:Content>
