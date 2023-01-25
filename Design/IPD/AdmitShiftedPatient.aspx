<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AdmitShiftedPatient.aspx.cs" Inherits="Design_IPD_AdmitShiftedPatient" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

        <div id="Pbody_box_inventory">
         <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" >
        
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
                <b>Admit Patient To Main Hospital</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <table style="width: 100%;">
                <tr>
                    <td  style="text-align:right;width:20%">
                        IPD No :&nbsp;
                    </td>
                    <td  style="width: 30%;text-align:left" >
                        <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static" Width="170px" MaxLength="10"
                            TabIndex="1"></asp:TextBox>
                      
                    </td>
                    <td style="text-align:right;width:20%">
                        UHID :&nbsp;
                    </td>
                    <td style="text-align:left;width:30%">
                        <asp:TextBox ID="txtMRNo" runat="server" ClientIDMode="Static" MaxLength="20" 
                            Width="170px" TabIndex="2"></asp:TextBox>
                       
                    </td>
                </tr>
                <tr>
                    <td  style="text-align:right">
                        Patient Name :&nbsp;
                    </td>
                    <td  style="width: 264px;text-align:left">
                        <asp:TextBox ID="txtPatientName" runat="server" ClientIDMode="Static" Width="170px" MaxLength="50"
                            TabIndex="3"></asp:TextBox>
                      
                    </td>
                    <td style="text-align:right;width:20%">
                        Centre :&nbsp;
                    </td>
                    <td style="text-align:left;width:30%">
                       <asp:DropDownList ID="ddlCentre" runat="server" TabIndex="4" Width="170px"  ClientIDMode="Static"></asp:DropDownList>
                       
                    </td>
                  
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" value="Search" class="ItDoseButton" onclick="search()" />
        </div>
             <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="searchOutData">
                 <table  style="width: 100%; border-collapse:collapse" >
                <tr>
                    <td colspan="4">
                        <div id="patientSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                        <br />
                       
                    </td>
                </tr>
            </table>
                 </div>
            <asp:Button ID="btnEdit" runat="server"  style="display:none" />
            <cc1:ModalPopupExtender ID="mpEdit" runat="server" 
            DropShadow="true" TargetControlID="btnEdit" BackgroundCssClass="filterPupupBackground" BehaviorID="mpEdit"
            PopupControlID="PnlEdit"  >
        </cc1:ModalPopupExtender>
             <asp:Panel ID="PnlEdit" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="760px" Height="280px">
            <div class="Purchaseheader"  >
                <b>Admit Patient</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 <em ><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeEdit()"/>
                               
                                to close</span></em>
            </div>

              <table style="width:100%;border-collapse:collapse">
                  <tr>
                      <td colspan="4" style="text-align:center">
                          <asp:Label ID="lblError" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
                      <asp:Label ID="lblTID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                          <asp:Label ID="lblPatientID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                          <asp:Label ID="lblShiftedID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                          <asp:Label ID="lblPanelID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                          <asp:Label ID="lblBillingCategory" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                          <asp:Label ID="lblScheduleChargeID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
 
                             </td>
                  </tr>
                  <tr>
                        <td style="text-align: right; width: 15%;">Doctor :&nbsp;
                        </td>
                        <td style="text-align: left; width: 35%;" >
                            <asp:DropDownList ID="ddlDoctor" runat="server"  ClientIDMode="Static"
                                Width="190px" >
                            </asp:DropDownList>
                            <asp:Label ID="Label12" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                           <img src="../../Images/edit.png" Style="cursor:pointer;display:none" title="Click To Add Doctor" id="imgAdd" onclick="addDoctor()" />
                            <img src="../../Images/Delete.gif" Style="cursor:pointer;display:none" title="Click To Remove Doctor" id="imbRemove" onclick="removeDoc()"/>
                       
                        </td>
                        <td style="text-align: left;" colspan="2">
                            <asp:Label ID="lblDocName" runat="server" CssClass="ItDoseLblSpBl" style="display:none" ClientIDMode="Static"></asp:Label><asp:Label
                                ID="lblDocName1" runat="server" CssClass="ItDoseLblSpBl" style="display:none" ClientIDMode="Static"></asp:Label>
                            <asp:Label ID="lblDocChk" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                        </td>
                        
                    </tr>
                  <tr>
                        <td style="text-align: right; width: 15%;">Room&nbsp;Type&nbsp;:&nbsp;
                        </td>
                        <td style="text-align: left; width:35%;" >
                            <asp:DropDownList ID="ddlCaseType" runat="server"  ClientIDMode="Static"
                                 ToolTip="Select Room Type" Width="190px" onchange="getRoomType($(this).val())">
                            </asp:DropDownList>
                            <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                           
                        </td>
                        <td style="text-align: right; width: 20%;">Room&nbsp;/Bed&nbsp;No.&nbsp;:&nbsp;
                        </td>
                        <td style="text-align: left; width: 30%;">
                            <asp:DropDownList ID="ddlRoom" runat="server"  ToolTip="Select Room /Bed No."
                                Width="190px" ClientIDMode="Static">
                            </asp:DropDownList>
                            <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                           
                        </td>
                    </tr>
                  <tr>
                        <td style="text-align: right; width: 15%;">Billing&nbsp;Category&nbsp;:&nbsp;
                        </td>
                        <td style="text-align: left; width: 35%;" >
                            <asp:DropDownList ID="ddlBillCategory" ClientIDMode="Static" runat="server" Width="190px"  ToolTip="Select Billing Category">
                            </asp:DropDownList>
                            <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                          
                        </td>
                        <td style="text-align: right; width: 20%;">Panel :&nbsp;
                        </td>
                        <td style="text-align: left; width: 30%;">
                          <asp:DropDownList ID="ddlPanelCompany" ClientIDMode="Static" runat="server"  Width="190px" ToolTip="Select Panel"
                                  onchange="Iscash();">
                            </asp:DropDownList>
                        </td>
                    </tr>
                   <tr>
                        <td style="text-align: right; width: 15%;">Parent Panel :&nbsp;
                        </td>
                        <td style="text-align: left; width: 35%;" >
                             <asp:DropDownList ID="ddlParentPanel" runat="server" ClientIDMode="Static"   Width="190px" EnableTheming="True"
                                ToolTip="Select Parent Panel">
                            </asp:DropDownList>
                            <asp:Label ID="Label11" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                          
                        </td>
                        <td style="text-align: right; width: 20%;">
                            <asp:Label ID="lblPolicyNo" runat="server" Text="Policy No. :&nbsp"></asp:Label>
                        </td>
                        <td style="text-align: left; width: 30%;">
                           <asp:TextBox ID="txtPolicyNo" runat="server"  Width="184px"
                                 ToolTip="Enter Policy No." MaxLength="20" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbPolicy" runat="server" TargetControlID="txtPolicyNo"
                                FilterType="LowercaseLetters,Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                  <tr>                        
                        <td style="text-align: right; width: 15%;">
                            Credit Limit :&nbsp;</td>
                        <td style="text-align: left;width: 35%;">
                            <table style="width:100%">
                                <tr>
                                    <td style="width:20%">                                  
                                        <asp:RadioButtonList ID="rdoCreditType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"   onclick="chkCreditType()">
                                            <asp:ListItem Value="A" Selected="True" Text="Amt."></asp:ListItem>
                                             <asp:ListItem Value="P"  Text="Per."></asp:ListItem>
                                        </asp:RadioButtonList>
                                         </td>
                                        <td style="width:30%">
                            <asp:TextBox ID="txtCrLimit" onpaste="return false" onkeyup="chkCrLimit()" runat="server"  Width="80px" AutoCompleteType="Disabled"
                                ToolTip="Enter Credit Limit" onkeypress="return checkForSecondDecimalDR(this,event)" MaxLength="10" ClientIDMode="Static"></asp:TextBox>
  </td>
                                </tr>
                                        </table>
                                   </td>
                       <td style="text-align: left;width: 15%;" colspan="2">                         
                            <asp:TextBox ID="txtCreditLimitType" Style="display:none"  Width="20px" ClientIDMode="Static" runat="server"></asp:TextBox>
                           <asp:TextBox ID="txtCreditLimit" Style="display:none"  Width="20px" ClientIDMode="Static" runat="server"></asp:TextBox>
                                          <cc1:FilteredTextBoxExtender ID="ftbCrLimit" runat="server" TargetControlID="txtCrLimit"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>                                                                                          
                              <asp:CheckBox ID="chkBillingCategory" CssClass="BillingCategory" Style="display:none" runat="server" Text="Change Billing Category"                               
                                 ClientIDMode="Static" />
                         
                               <asp:CheckBox ID="chkPanel" CssClass="panelCheck" Style="display:none" runat="server" Text="Change Panel"                               
                                 ClientIDMode="Static" />
                                </td>                         
                    </tr>
                   <tr>
                        <td style="text-align: right; width: 15%;">
                           <asp:Label ID="lblCardNo" runat="server" Text="Card No. :&nbsp"></asp:Label>
                        </td>
                        <td style="text-align: left; width: 35%;" >
                           <asp:TextBox ID="txtCardNo" runat="server"  Width="184px"
                                 ToolTip="Enter Card No." MaxLength="30" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbCard" runat="server" TargetControlID="txtCardNo"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: left; " colspan="2">
                             <asp:CheckBox ID="chkPolicyDetail" CssClass="PolicyDetail" runat="server" Text="Ignore Policy Detail's check"                               
                                onclick="chkPolicy();" ClientIDMode="Static" />
                        </td>                    
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 15%;">Card&nbsp;Holder&nbsp;Name&nbsp;:&nbsp;
                        </td>
                        <td style="text-align: left; width: 35%;" >
                            <asp:TextBox ID="txtCardHolderName" runat="server" CssClass="ItDoseTextinputText"  Width="184px"
                                onkeypress="return check2(event)" onkeyup="validatespace();" AutoCompleteType="Disabled"
                                ToolTip="Enter Card Holder Name" MaxLength="50" ClientIDMode="Static"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 20%;">
                            <asp:Label ID="lblPolicyReason" runat="server" Text="Ignoring&nbsp;Policy&nbsp;Reason&nbsp;:&nbsp;"
                                ClientIDMode="Static" Style="display: none;"></asp:Label>
                        </td>
                        <td style="text-align: left; width: 30%;">
                            <asp:TextBox ID="txtIgnoringPolicyReason" runat="server"
                                Style="display: none;" Width="184px"  ClientIDMode="Static" MaxLength="50"></asp:TextBox>
                            <asp:Label ID="Label18" runat="server" ClientIDMode="Static" Style="color: Red; font-size: 10px; display: none;"
                                Text="*"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 15%;">Relation&nbsp;With&nbsp;CH&nbsp;:&nbsp;
                        </td>
                        <td style="text-align: left; width: 35%;" >
                            <asp:DropDownList ID="ddlHolder_Relation" runat="server"  Width="190px"
                                ToolTip="Select Relation With CH" ClientIDMode="Static">
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right; width: 20%;">
                        </td>
                        <td style="text-align: left; width: 30%;">
                        </td>
                    </tr>
                <tr>
                    <td colspan="4" style="text-align:center">
                         <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="save()" />
                    </td>
                </tr>
                 
                    
                       </table>
                 </asp:Panel>

            
    </div>
    <script type="text/javascript">
        function search() {
            $("#<%=lblMsg.ClientID%>").text('');
            $.ajax({
                url: "AdmitShiftedPatient.aspx/searchShiftedPatient",
                data: '{IPDNo:"' + $('#txtIPDNo').val() + '",PatientID:"' + $('#txtMRNo').val() + '",PName:"' + $('#txtPatientName').val() + '",Centre:"' + $('#ddlCentre').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    searchData = jQuery.parseJSON(result.d);
                    if (searchData != null) {
                        var output = $('#tb_Search').parseTemplate(searchData);
                        $('#patientSearchOutput').html(output);
                        $('#patientSearchOutput,#searchOutData').show();
                    }
                    else {
                        $("#<%=lblMsg.ClientID%>").text('Record Not Found');
                        $('#patientSearchOutput').html('');
                        $('#patientSearchOutput,#searchOutData').hide();
                    }
                },
                error: function (xhr, status) {
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                }
            });
        }
    </script>
    <script id="tb_Search" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:940px;border-collapse:collapse;">
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Edit</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">IPD No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Patient Name</th>            
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Shifted Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Shifted By</th>         
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Shifted Date</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Panel Name</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th>    
		</tr>
        <#
        var dataLength=searchData.length;      
        var objRow;    
        for(var j=0;j<dataLength;j++)
        {
        objRow = searchData[j];
        #>
                    <tr id="<#=j+1#>">
                        <td class="GridViewLabItemStyle" id="td1"  style="width:40px;text-align:center" >
                            <img src="../../Images/edit.png" style="cursor:pointer" onclick="editAdd(this)" />
                            </td>
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
    <td class="GridViewLabItemStyle" id="tdTID"  style="width:40px;text-align:center" ><#=objRow.TID#></td>
    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:100px;text-align:left" ><#=objRow.PatientID#></td>                                                                  
    <td class="GridViewLabItemStyle" id="tdPName" style="width:180px;text-align:left"><#=objRow.PName#></td>
    <td class="GridViewLabItemStyle" id="tdShiftedCentre" style="width:120px;text-align:left"><#=objRow.CentreName#></td>
    <td class="GridViewLabItemStyle" id="tdShiftedName" style="width:120px;text-align:left"><#=objRow.ShiftedName#></td>
    <td class="GridViewLabItemStyle" id="tdShiftedDate" style="width:90px;text-align:center"><#=objRow.ShiftedDate#></td>
    <td class="GridViewLabItemStyle" id="tdPanelName" style="width:100px;text-align:center"><#=objRow.PanelName#></td>

                        
    <td class="GridViewLabItemStyle" id="tdTransactionID"  style="width:40px;text-align:center;display:none" ><#=objRow.TransactionID#></td>
    <td class="GridViewLabItemStyle" id="tdshiftedID"  style="width:40px;text-align:center;display:none" ><#=objRow.shiftedID#></td>
    <td class="GridViewLabItemStyle" id="tdPanelID"  style="width:40px;text-align:center;display:none" ><#=objRow.PanelID#></td>
    <td class="GridViewLabItemStyle" id="tdReferenceCode"  style="width:40px;text-align:center;display:none" ><#=objRow.ReferenceCode#></td>
    <td class="GridViewLabItemStyle" id="tdapplyCreditLimit"  style="width:40px;text-align:center;display:none" ><#=objRow.applyCreditLimit#></td>
          <td class="GridViewLabItemStyle" id="tdBillingCategory"  style="width:40px;text-align:center;display:none" ><#=objRow.billingCategory#></td>
                  
                         </tr>
        <#}
        #>     
     </table>
    </script>
    <script type="text/javascript">
        function editAdd(rowID) {
            $("#lblPanelID").text($(rowID).closest('tr').find('#tdPanelID').text());
            var count = getPanelMapped($("#lblPanelID").text(), $(rowID).closest('tr').find('#tdPanelName').text());
            if (count != "0") {
                $("#lblShiftedID").text($(rowID).closest('tr').find('#tdshiftedID').text());
                $("#lblTID").text($(rowID).closest('tr').find('#tdTransactionID').text());
                $("#lblPatientID").text($(rowID).closest('tr').find('#tdPatientID').text());
                var panelID = $(rowID).closest('tr').find('#tdPanelID').text() + "#" + $(rowID).closest('tr').find('#tdReferenceCode').text() + "#" + $(rowID).closest('tr').find('#tdapplyCreditLimit').text();
                $("#<%=ddlPanelCompany.ClientID %>").val(panelID);

              $find('mpEdit').show();

              loadPatientData($("#lblTID").text());
          }
      }
        </script>
    <script type="text/javascript">
        function getRoomType(id) {
            $("#<%=ddlBillCategory.ClientID %>").val(id);           
           // alert($('#lblBillingCategory').text());
           // alert($("#<%=ddlBillCategory.ClientID %>").val());
            if ($('#lblBillingCategory').text() != $("#<%=ddlBillCategory.ClientID %>").val()) {              
                $(".BillingCategory").show();
            }
            else {
                $(".BillingCategory").hide().attr('checked', false);
            }
            if ($("#<%=ddlBillCategory.ClientID %>").val() == "0") {
                $(".BillingCategory").hide().attr('checked', false);
            }
            room();
        }
        function room() {
            var BillCategory = $("#<%=ddlRoom.ClientID %>");
            $("#<%=ddlRoom.ClientID %> option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/getRoomType",
                data: '{ CaseType: "' + $("#<%=ddlCaseType.ClientID %>").val() + '"}',
                type: "POST",
                async: false,
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    BillCategoryData = jQuery.parseJSON(result.d);
                    if (BillCategoryData.length == 0) {
                        BillCategory.append($("<option></option>").val("0").html("NO Room Available"));
                    }
                    else {
                        BillCategory.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < BillCategoryData.length; i++) {
                            BillCategory.append($("<option></option>").val(BillCategoryData[i].Room_Id).html(BillCategoryData[i].Name));
                        }
                    }
                    BillCategory.attr("disabled", false);
                },
                error: function (xhr, status) {
                    alert("Error ");
                    BillCategory.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                closeEdit()
            }
        }
        function closeEdit() {
            if ($find('mpEdit')) {
                $find('mpEdit').hide();
            }
        }
          </script>
    <script type="text/javascript">
        function addDoctor() {
            $("#lblError").text('');
            if ($("#ddlDoctor").val() == "0") {
                $("#lblError").text("Please Select Doctor ");
                $("#ddlDoctor").focus();
                return;
            }
            var con = 0;
            if ($.trim($("#lblDocChk").text()) == "") {
                $("#lblDocChk").text($("#ddlDoctor").val());
            }
            else {
                for (var i = 0; i < $("#lblDocChk").text().trim().split('#').length; i++) {
                    if ($("#ddlDoctor").val() == $("#lblDocChk").text().trim().split('#')[i]) {
                        $("#lblError").text("Doctor Already Selected");
                        con = 1;
                        return;
                    }
                }
                $("#lblDocChk").text($("#lblDocChk").text().trim() + "#" + $("#ddlDoctor").val());

            }
            if (con == 0) {
                if ($("#lblDocName").text().trim() == "") {
                    $("#lblDocName").text(" 1. " + $("#ddlDoctor option:selected").text()).show();
                    $("#lblDocChk").text($("#ddlDoctor").val());
                }

                else if (($("#lblDocName").text().trim() != "") && ($("#lblDocName1").text() == "")) {
                    $("#lblDocName1").text(" 2. " + $("#ddlDoctor option:selected").text()).show();
                    $("#lblDocChk").text($("#ddlDoctor").val());
                }
            }
        }
        function removeDoc() {
            if ($("#lblDocName1").text().trim() != "")
                $("#lblDocName1").text('');
            else if ($("#lblDocName").text().trim() != "")
                $("#lblDocName").text('');


            var length = $("#lblDocChk").text().trim().split('#').length;
            if (length > 0) {
                var Value1 = "";
                for (var i = 1; i < length; i++) {
                    if (Value1 == "")
                        Value1 = $("#lblDocChk").text().trim().split('#')[length - (i + 1)];
                    else
                        Value1 = Value1 + "#" + $("#lblDocChk").text().trim().split('#')[length - (i + 1)];
                }
                $("#lblDocChk").text(Value1);
            }
        }
           </script>
    <script type="text/javascript">
        function save() {
            $("#lblError").text('');
            //if ($("#lblDocName").text().trim() == "") {
            //    $("#lblError").text("Please Select Doctor");
            //    $("#ddlDoctor").focus();
            //    return;
            //}
            if ($("#ddlDoctor").val() == "0") {
                $("#lblError").text("Please Select Doctor");
                $("#ddlDoctor").focus();
                return;
            }
            if ($("#ddlCaseType").val() == "0") {
                $("#lblError").text("Please Select Room Type");
                $("#ddlCaseType").focus();
                return;
            }
            if ($("#ddlRoom").val() == "0") {
                $("#lblError").text("Please Select Room /Bed No.");
                $("#ddlRoom").focus();
                return;
            }
            if ($("#ddlBillCategory").val() == "0") {
                $("#lblError").text("Please Select Billing Category");
                $("#ddlBillCategory").focus();
                return;
            }
            if ($("#ddlParentPanel").val() == "0") {
                $("#lblError").text("Please Select Parent Panel");
                $("#ddlParentPanel").focus();
                return;
            }
            if (($(".PolicyDetail input[type=checkbox]").is(':checked')) && ($.trim($("#txtIgnoringPolicyReason").val()) == "")) {
                $("#lblError").text("Please Enter Ignoring Policy Reason ");
                $("#txtIgnoringPolicyReason").focus();
                return;
            }

            if (($(".PolicyDetail input[type=checkbox]").is(':checked') == false) && ($("#<%=ddlPanelCompany.ClientID %>").val().split('#')[2] != "0")) {
                if ($.trim($("#txtCrLimit").val()) == "") {
                    $("#lblError").text('Please Enter Credit Limit OR Check Ignore Policy Detail Check ');
                    $("#txtCrLimit").focus();

                    return false;
                }
                if (($.trim($("#txtPolicyNo").val()) == "") && (parseFloat($("#txtCrLimit").val()) > 0)) {
                    $("#lblError").text('Please Enter Policy No. OR Check Ignore Policy Detail Check ');
                    $("#txtPolicyNo").focus();
                    return false;
                }
            }
            var RelationWith_holder = "";
            if ($("#ddlHolder_Relation").val() != "0")
                RelationWith_holder = $("#ddlHolder_Relation").val();

            var CreditType = $.trim($('#rdoCreditType input[type:radio]:checked').val());

            var PolicyDetail = 0;
            var IgnoringPolicyReason = "";
            if ($("#chkPolicyDetail input[type=checkbox]").is(':checked')) {
                PolicyDetail = 1;
                IgnoringPolicyReason = $.trim($('#txtIgnoringPolicyReason').val());
            }
            var BillingCategory = 0;
            if ($('.BillingCategory input[type=checkbox]').is(':checked')) {
                BillingCategory = 1;
            }
            var panelCheck = 0;
            if ($('.panelCheck input[type=checkbox]').is(':checked')) {
                panelCheck = 1;
            }

            $.ajax({
                url: "AdmitShiftedPatient.aspx/saveShiftedPatient",
                data: '{roomType:"' + $('#ddlCaseType').val() + '",BillCategory:"' + $('#ddlBillCategory').val() + '",roomID:"' + $('#ddlRoom').val() + '",PatientID:"' + $('#lblPatientID').text().trim() + '",TID:"' + $('#lblTID').text().trim() + '",docID:"' + $('#ddlDoctor').val() + '",panelID:"' + $('#lblPanelID').text() + '",ShiftedID:"' + $("#lblShiftedID").text() + '",parentPanelID:"' + $("#ddlParentPanel").val() + '",PolicyNo:"' + $("#txtPolicyNo").val() + '",CardNo:"' + $("#txtCardNo").val() + '",CardHolderName:"' + $("#txtCardHolderName").val() + '",RelationWith_holder:"' + RelationWith_holder + '",CreditLimit:"' + $("#txtCrLimit").val() + '",CreditType:"' + CreditType + '",PolicyDetail:"' + PolicyDetail + '",IgnoringPolicyReason:"' + IgnoringPolicyReason + '",BillingCategory:"' + BillingCategory + '",panelCheck:"' + panelCheck + '",ScheduleChargeID:"' + $("#lblScheduleChargeID").text() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data == "1") {
                        $find('mpEdit').hide();
                        clearAllControl();
                        search();
                        $("#<%=lblMsg.ClientID%>").text('Record Saved Successfully');
                    }
                    else {
                        $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    }
                },
                error: function (xhr, status) {
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');

                }
            });

        }

        function clearAllControl() {
            jQuery("input[type=text], textarea").val('');
            jQuery("#ddlHolder_Relation,#ddlPanelCompany,#ddlDoctor,#ddlCaseType,#ddlBillCategory").prop('selectedIndex', 0);
            $(".BillingCategory").hide().attr('checked', false);
            $('.panelCheck').hide().attr('checked', false);
            $("#chkPolicyDetail input[type=checkbox]").attr('checked', false);
            $("#<%= rdoCreditType.ClientID %> input[value='A']").attr('checked', 'checked');
            $('#lblPolicyReason,#Label18').hide();
            $('#txtIgnoringPolicyReason').hide();
            $('#ddlHolder_Relation').get(0).selectedIndex = 0;
        }
         </script>
    <script type="text/javascript">
        function Iscash() {
            $("#<%=ddlParentPanel.ClientID %> option").remove();

            if ($('#lblPanelID').text() != $("#<%=ddlPanelCompany.ClientID %>").val().split('#')[0]) {
                $('.panelCheck').show();
            }
            else {
                $('.panelCheck').hide().attr('checked', false);
            }
         $.ajax({
             url: "../Common/CommonService.asmx/bindParentPanel",
             data: '{ PanelCompany: "' + $("#<%=ddlPanelCompany.ClientID %>").val().split('#')[0] + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    Company = jQuery.parseJSON(result.d);
                    $("#<%=ddlParentPanel.ClientID %>").append($("<option></option>").val("0").html("Select"));

                    for (i = 0; i < Company.length; i++) {
                        $("#<%=ddlParentPanel.ClientID %>").append($("<option></option>").val(Company[i].PanelID).html(Company[i].Company_Name));
                        if (($("#<%=ddlPanelCompany.ClientID %>").val().split('#')[0] == Company[i].PanelID) && ($("#<%=ddlPanelCompany.ClientID %>").val().split('#')[2] != "0")) {
                            $('#txtCrLimit').val(Company[i].CreditLimit).removeAttr('disabled');
                            $('#txtCreditLimit').val(Company[i].CreditLimit);
                            $('#txtCreditLimitType').val(Company[i].CreditLimitType);
                            $("#<%= rdoCreditType.ClientID %> input[value='" + Company[i].CreditLimitType + "']").attr('checked', 'checked');
                            $("#<%= rdoCreditType.ClientID %>").removeAttr('disabled');
                        }
                    }

                    $("#<%=ddlParentPanel.ClientID %>").attr("disabled", false);
                    if ($("#<%=ddlPanelCompany.ClientID %>").val().split('#')[2] == "0") {
                        $('#chkPolicyDetail').attr('disabled', 'disabled').attr('checked', false);
                        $('#lblPolicyReason,#Label18').hide();
                        $('#txtIgnoringPolicyReason').val('').hide();
                        $('#txtPolicyNo,#txtCardNo,#txtCardHolderName').val('').attr('readOnly', 'true');
                        $('#ddlHolder_Relation').get(0).selectedIndex = 0;
                        $('#ddlHolder_Relation,#<%= rdoCreditType.ClientID %>').attr('disabled', 'disabled');
                        $('#txtCrLimit').val('').attr('disabled', 'disabled');
                    }
                    else {
                        $('#chkPolicyDetail,#ddlHolder_Relation,#<%= rdoCreditType.ClientID %>').removeAttr('disabled');
                        $('#txtPolicyNo,#txtCardHolderName').val('').removeAttr('readOnly');
                        if (($('#txtCrLimit').val() == "")) {
                            $('#txtCrLimit').val('0').removeAttr('disabled');
                            $('#txtCreditLimit').val('0');
                        }
                        else if (($('#txtCrLimit').val() > 0))
                            $('#txtCrLimit').removeAttr('disabled');
                        $('#ddlHolder_Relation').get(0).selectedIndex = 0;
                        if ($('#chkPolicyDetail').attr('checked')) {
                            $('#lblPolicyReason').show();
                            $('#txtIgnoringPolicyReason').show();
                            $('#Label18').show();
                        }



                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    $("#<%=ddlParentPanel.ClientID %>").attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
     </script>
    <script type="text/javascript">
        function chkCrLimit() {

            if (($.trim($('#rdoCreditType input[type:radio]:checked').val()) == "P") && ($("#<%=txtCrLimit.ClientID%>").val() > 100)) {
                $("#txtCrLimit").prop('maxLength', '5');
                $("#txtCrLimit").val('');
                alert('Please Enter Valid Percentage');
                if ($('#rdoCreditType input[type:radio]:checked').val() == $("#txtCreditLimitType").val()) {
                    $("#txtCrLimit").val($("#txtCreditLimit").val());
                }
            }
            else {
                $("#txtCrLimit").prop('maxLength', '10');
            }
            var DigitsAfterDecimal = 2;
            var perIndex = $.trim($('#txtCrLimit').val()).indexOf(".");
            if (perIndex > "0") {
                if ($.trim($('#txtCrLimit').val()).length - ($.trim($('#txtCrLimit').val()).indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Percentage, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $('#txtCrLimit').val($('#txtCrLimit').val().substring(0, ($('#txtCrLimit').val().length - 1)))
                }
            }
            
        }
        
        function chkCreditType() {
            if ($("#ddlPanelCompany").val().split('#')[2] == "0") {
                jQuery("#txtCrLimit").val('').attr('disabled', 'disabled');
                $('#rdoCreditType').attr('disabled', 'disabled');
            }
            else {
                $("#txtCrLimit").val('0').removeAttr('disabled');
                $('#rdoCreditType').removeAttr('disabled');
                if ($('#rdoCreditType input[type:radio]:checked').val() == $("#txtCreditLimitType").val()) {
                    $("#txtCrLimit").val($("#txtCreditLimit").val());
                }

            }
        }
        function checkForSecondDecimalDR(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            if (strVal.charAt(0) == "0") {
                sender.value = sender.value.substring(0, (sender.value.length - 1));
            }

            if ((strVal == "0") && (charCode == 48)) {
                strVal = Number(strVal);
                sender.value = sender.value.substring(0, (sender.value.length - 1));

            }
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
    </script>
    <script type="text/javascript">
       
        function chkPolicy() {
            if ($("#<%=ddlPanelCompany.ClientID %> option:selected").text() != 'CASH') {
                if ($('#chkPolicyDetail').attr('checked')) {
                    $('#lblPolicyReason,#txtIgnoringPolicyReason,#Label18').show();
                    $('#txtPolicyNo,#txtCardNo,#txtCardHolderName').val('').attr('readOnly', 'true');
                    $('#ddlHolder_Relation').get(0).selectedIndex = 0;
                    $('#ddlHolder_Relation').attr('disabled', 'disabled');
                    $('#txtCrLimit').val('0').attr('disabled', 'disabled');
                    $('#rdoCreditType').attr('disabled', 'disabled');
                }
                else {
                    $('#lblPolicyReason,#Label18').hide();
                    $('#txtIgnoringPolicyReason').val('').hide();
                    $('#txtPolicyNo,#txtCardNo,#txtCardHolderName').removeAttr('readOnly');
                    $('#ddlHolder_Relation').removeAttr('disabled');
                    $('#txtCrLimit,#rdoCreditType').removeAttr('disabled');
                }
            }
            else {
                $('#chkPolicyDetail').attr('disabled', 'disabled').attr('checked', false);
                $('#lblPolicyReason,#txtIgnoringPolicyReason,#Label18').hide();
                $('#txtPolicyNo,#txtCardNo,#txtCardHolderName').val('').attr('readOnly', 'true');
                $('#ddlHolder_Relation').get(0).selectedIndex = 0;
                $('#ddlHolder_Relation').attr('disabled', 'disabled');
                $('#txtCrLimit').attr('disabled', 'disabled');
                if ($('#chkPolicyDetail').attr('checked')) {
                    $('#lblPolicyReason,#Label18').show();
                    $('#txtIgnoringPolicyReason').val('').show();
                }
            }
        }
        function check2(e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            var card = $('#<%=txtCardHolderName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtCardHolderName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                return false;
            else
                return true;
        }
        function validatespace() {
            var card = $('#<%=txtCardHolderName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtCardHolderName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                return true;
            }
        }
    </script>
    <script type="text/javascript">
        function getPanelMapped(panelID, PanelName) {
            var data = 0;
            $("#<%=lblMsg.ClientID%>").text('');
            $.ajax({
                url: "AdmitShiftedPatient.aspx/getPanelMapped",
                data: '{ panelID: "' + panelID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    data = result.d;
                    if (result.d == "0") {
                        $("#<%=lblMsg.ClientID%>").text('Please Map Panel ( ' + PanelName + ' )With Centre ');
                    }
                }
            });
            return data;
        }
    </script>
    <script type="text/javascript" >
        function loadPatientData(TID) {
            $.ajax({
                url: "AdmitShiftedPatient.aspx/loadPatientInfo",
                data: '{ TID: "' + TID + '"}',
                type: "POST",
                async: false,
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    patientData = jQuery.parseJSON(result.d);
                    if (patientData != "") {
                        $('#txtCardNo').val(patientData[0]["CardNo"]);
                        $('#txtCardHolderName').val(patientData[0]["CardHolderName"]);
                        if (patientData[0]["RelationWith_holder"] != "")
                            $('#ddlHolder_Relation').val(patientData[0]["RelationWith_holder"]);
                        $('#txtPolicyNo').val(patientData[0]["PolicyNo"]);
                        $('#ddlCaseType').val(patientData[0]["IPDCaseType_ID"]);
                       // getRoomType(patientData[0]["IPDCaseType_ID"]);
                        $("#<%=ddlCaseType.ClientID %>").val(patientData[0]["IPDCaseType_ID"]);
                        $("#ddlBillCategory").val(patientData[0]["IPDCaseType_ID_Bill"]);
                        
                        room();
                        $('#lblBillingCategory').text(patientData[0]["IPDCaseType_ID_Bill"]);
                        $('#lblPanelID').text(patientData[0]["PanelID"]);
                        $('#lblScheduleChargeID').text(patientData[0]["ScheduleChargeID"]);
                        chkCrLimit();
                        chkPolicy();
                    }
                }
            });
        }
    </script>
</asp:Content>

