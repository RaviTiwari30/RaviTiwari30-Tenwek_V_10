<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ReturnBatchItem.aspx.cs" Inherits="Design_CSSD_ReturnBatchItem" EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <script type="text/javascript">
        var PatientData = "";
        $(document).ready(function () {

            loadData();
            $('#btnAddItem').click(AddItem);
            $('#btnSave').click(SaveData);
            $("#<%=ddlBatch.ClientID %>").change(AddItem);
        });





        function SaveData() {
            $("#<%=lblmsg.ClientID %>").text('');
            $('#btnSave').attr('disabled', true);
            var Itemdata = "";
            var ItemData = $("#<%=ddlBatch.ClientID %> option:selected").val();
            if ($("#<%=ddlBatch.ClientID %> option:selected").text().toUpperCase() == "SELECT" || ItemData == "0") {
                DisplayMsg('MM245', 'ctl00_ContentPlaceHolder1_lblmsg');
               // $("#<%=lblmsg.ClientID %>").text('Please Select Batch Name');
                $("#<%=ddlBatch.ClientID %>").focus();
                return;
            }



            $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {

                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") {

                    Itemdata += $rowid.find('#BatchTnxID').text() + '|' + $rowid.find('#SetID').text() + '|' + $rowid.find('#SetStockID').text() + '|' + $rowid.find('#StockID').text() + '|' + $rowid.find('#ItemID').text() + '|' + $rowid.find('#Qty').text() + '|' + $rowid.find('#IsSet').text() + "#";
                }
            });




            if (Itemdata == "") {
                DisplayMsg('MM018', 'ctl00_ContentPlaceHolder1_lblmsg');
                //$("#<%=lblmsg.ClientID %>").text('Please Select Item');
                $("#btnSave").attr('disabled', false);
                return;
            }


            $.ajax({

                url: "Services/RetunBatch.asmx/ReturnBatchData",
                data: '{ItemData: "' + Itemdata + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        //$('ddlSetItem').find('selected', 'selected')
                        $("#tb_grdLabSearch tr:not(:first)").remove();
                        $("#tb_grdLabSearch").hide();
                        DisplayMsg('MM01', 'ctl00_ContentPlaceHolder1_lblmsg');
                        //$("#<%=lblmsg.ClientID %>").text('Record Saved Successfully');
                        loadData();
                        $('#<%=txtRemark.ClientID %>').val('');
                        $("#btnSave").hide();
                        $('#BoilerDetail').attr('style', 'display:none');
                    }
                    else {
                        DisplayMsg('MM07', 'ctl00_ContentPlaceHolder1_lblmsg');
                        //$("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                    }

                    $("#btnSave").attr('disabled', false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                    //$("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                    $("#btnSave").attr('disabled', false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }




        function AddItem() {
            $("#<%=lblmsg.ClientID %>").text('');
            var ItemData = $("#<%=ddlBatch.ClientID %> option:selected").val();
            if ($("#<%=ddlBatch.ClientID %> option:selected").text().toUpperCase() == "SELECT" || ItemData == "0") {
                DisplayMsg('MM245', 'ctl00_ContentPlaceHolder1_lblmsg');
                //$("#<%=lblmsg.ClientID %>").text('Please Select Batch Name');
                $("#<%=ddlBatch.ClientID %>").focus();
                $('#BoilerDetail').attr('style', 'display:none');
                $('#PatientLabSearchOutput').hide();
                return;
            }

            $.ajax({
                url: "Services/RetunBatch.asmx/LoadBatchDetailReturn",
                data: '{BatchNo:"' + ItemData + '"}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                    $('#PatientLabSearchOutput').html(output);
                    $('#BoilerDetail').attr('style', 'display:""');
                    $('#PatientLabSearchOutput').show();
                    $("#btnSave").attr('disabled', false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                    $("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
        }



        function loadData() {
            $("#<%=ddlBatch.ClientID %> option").remove();
            var ddlBatch = $("#<%=ddlBatch.ClientID %>");
            ddlBatch.attr("disabled", true);

            $.ajax({
                url: "Services/RetunBatch.asmx/LoadBatchReturn",
                data: '{}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    PatientData = jQuery.parseJSON(result.d);

                    if (PatientData.length == 0) {
                        ddlBatch.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        ddlBatch.append($("<option></option>").val("Select").html("Select"))
                        for (i = 0; i < PatientData.length; i++) {
                            ddlBatch.append($("<option></option>").val(PatientData[i]["BatchNo"]).html(PatientData[i]["BatchName"]));
                        }

                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                    //$("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
            ddlBatch.attr("disabled", false);

        }

        function checkAll(checkbox) {
            $("#tb_grdLabSearch tr").each(function () {
                // alert(checked.checked);
                $(this).find("#chk").attr("checked", checkbox.checked);
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

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Return Process Batch</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
            </asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 30%">
                        &nbsp;
                    </td>
                    <td style="width: 15%">
                        &nbsp;
                    </td>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 31%">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 22%">
                        Select Batch Name :&nbsp;
                    </td>
                    <td align="left" colspan="4">
                        <asp:DropDownList ID="ddlBatch" ToolTip="Select Batch Name" runat="server" Width="250px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 30%">
                        &nbsp;
                    </td>
                    <td style="width: 15%">
                        &nbsp;
                    </td>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 31%">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 30%">
                        <input type="button" value="Add Item" id="btnAddItem" class="ItDoseButton" style="display:none" />
                    </td>
                    <td style="width: 15%">
                        &nbsp;
                    </td>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 31%">
                    </td>
                </tr>
                <tr>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 30%">
                    </td>
                    <td style="width: 15%">
                    </td>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 31%">
                    </td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td colspan="5">
                        <div class="content" id="PatientLabSearchOutput" style="max-height: 400px; overflow-y: auto;
                            overflow-x: auto;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" id="BoilerDetail" style="display: none;">
                <table width="100%">
                    <tr>
                        <td style="width: 19%; height: 18px; text-align: right">
                            Remark :&nbsp;
                        </td>
                        <td style="height: 18px; text-align: left">
                            <asp:TextBox ID="txtRemark" MaxLength="100" ToolTip="Enter Remark" runat="server"
                                Width="327px" onkeypress="return check(event)"></asp:TextBox>
                        </td>
                        <td style="height: 18px; text-align: left">
                        </td>
                        <td style="height: 18px; text-align: left; width: 261px;">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 19%; height: 18px; text-align: right">
                        </td>
                        <td colspan="2" style="height: 18px; text-align: center">
                            <input type="button" value="Save" class="ItDoseButton" id="btnSave" title="Click To Save" />
                        </td>
                        <td style="height: 18px; text-align: left; width: 261px;">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script id="tb_PatientLabSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
    style="width:910px;border-collapse:collapse;">
		<tr id="Header">

<th class="GridViewHeaderStyle" scope="col" style="width:10px;"><input type="checkbox" onclick="checkAll(this);"/></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Batch Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Boiler Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Actual Start Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Actual End Date</th>
			
            <th class="GridViewHeaderStyle" scope="col" style="width:5px;">Set Name</th>
            
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:5px;">Qty.</th>
            
        </tr>

        <#
       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
        #>
                    <tr id="<#=j+1#>">
              
                    <td class="GridViewLabItemStyle"><input type="checkbox" id="chk" /></td>

                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="BatchNo" style="display:none"><#=objRow.BatchNo#></td>
                    <td class="GridViewLabItemStyle" id="BatchName"><#=objRow.BatchName#></td>
                    <td class="GridViewLabItemStyle" id="BoilerName"><#=objRow.BoilerName#></td>
                    <td class="GridViewLabItemStyle" id="ActualStartDate"><#=objRow.ActualStartDate#></td>
                    <td class="GridViewLabItemStyle" id="ActualEndDate"><#=objRow.ActualEndDate#></td>
                    <td class="GridViewLabItemStyle" id="SetID"  style="display:none"><#=objRow.SetID#></td>
                    <td class="GridViewLabItemStyle" id="SetName"><#=objRow.SetName#></td>
                    <td class="GridViewLabItemStyle" id="ItemID"  style="display:none"><#=objRow.ItemID#></td>
                    <td class="GridViewLabItemStyle" id="ItemName"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="Qty"><#=objRow.Qty#></td>
                    <td class="GridViewLabItemStyle" id="IsSet"  style="display:none"><#=objRow.IsSet#></td>
                    <td class="GridViewLabItemStyle" id="SetStockID" style="display:none"><#=objRow.SetStockID#></td>
                    <td class="GridViewLabItemStyle" id="StockID"  style="display:none"><#=objRow.StockID#></td>
                    <td class="GridViewLabItemStyle" id="BatchTnxID"  style="display:none"><#=objRow.BatchTnxID#></td>
                    
                    
                    
                    
                    </tr>

        <#}#>

     </table>    
    </script>
</asp:Content>
