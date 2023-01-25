<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDBill_PrintSetting.aspx.cs" Inherits="Design_EDP_IPDBill_PrintSetting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align:center">
                    <b>IPD Bill Print Setting</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                IPD Bill Print Setting
            </div>
            <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Bill Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddsettingtype" onchange="bindselectiontype(function () { });">
                                    <option value="DETMIXCONFIG">Config Wise</option>
                                    <option value="DETMIXDISP">Display Name Wise</option>
                                </select>
                            </div>
                            <div class="col-md-3"><label class="pull-left">Selection Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlselectiontype"></select>
                            </div>
                             <div class="col-md-5">
                              <input type="button" id="btnsearch" onclick="$bindbillprintsetting()" value="Search" />
                            </div>
                        </div></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center"><input type="hidden" id="hdnid" value="0" />
            <input type="button" id="btnsave" onclick="SaveSelectionType(this)" value="Save" />
                <input type="button" id="btnCancell" onclick="CancelSelectionType()" value="Cancel" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div id="div_result" style="overflow:auto;max-height:410px" class="col-md-24"></div>            
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            bindselectiontype(function () {
            });
        });
        $bindbillprintsetting = function () {
            var data = {
                BillType: $('#ddsettingtype').val(),
                Type: $('#ddlselectiontype').val()
            }
            serverCall('IPDBill_PrintSetting.aspx/bindbillprintsetting', data, function (response) {
                templateData = JSON.parse(response);
                if (templateData.length > 0) {
                    var parseHTML = $('#templateSearchDetails').parseTemplate(templateData);
                    $('#div_result').removeClass('hidden').html(parseHTML);
                    if ($('#ddsettingtype').val() == 'DETMIXCONFIG')
                        $('#tdName').html('Config Name');
                    else
                        $('#tdName').html('Display Name');
                }
                else {
                    $('#div_result').addClass('hidden').html("");
                    modelAlert('Record Not Found');
                }
            });
        }
       
        var bindselectiontype = function (callback) {
            serverCall('IPDBill_PrintSetting.aspx/bindselectiontype', { type: $('#ddsettingtype').val() }, function (response) {
                var responseData = JSON.parse(response);
                var ddlselectiontype = $('#ddlselectiontype');
                ddlselectiontype.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'Value', textField: 'Text', isSearchAble: true });
                callback(true);
               
            });
        }
        var SaveSelectionType = function (btnSave) {           
            if ($.trim($("#ddlselectiontype").val()) == "0") {
                modelAlert('Please Select Selection Type');
                return false;
            }
            var data = {
                BillType: $.trim($('#ddsettingtype').val()),
                Type: $.trim($('#ddlselectiontype').val()),
                ID: $.trim($('#hdnid').val()),
            }
            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('IPDBill_PrintSetting.aspx/SaveIPDBillSetting', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (!responseData.status) {
                        console.log(responseData.message);
                        if($.trim($('#hdnid').val())=='0')
                        $(btnSave).removeAttr('disabled').val('Save');
                    else
                         $(btnSave).removeAttr('disabled').val('Update');
                    }
                    else {
                        $('#hdnid').val('0');
                        $bindbillprintsetting();
                        $(btnSave).removeAttr('disabled').val('Save');
                        //CancelSelectionType();
                       
                    }
                });
            });
        }
        var EditDetails = function (el) {
            $('#hdnid').val($.trim($(el).closest('tr').find('.lblID').text()));
            $('#ddsettingtype').val($.trim($(el).closest('tr').find('.lblPrintType').text())).chosen('destroy').chosen();
            bindselectiontype(function () {
                if ($.trim($(el).closest('tr').find('.lblPrintType').text()) == 'DETMIXDISP') {
                    $('#ddlselectiontype').val($.trim($(el).closest('tr').find('.lblDisplayName').text())).chosen('destroy').chosen();;
                }
                else {
                    $('#ddlselectiontype').val($.trim($(el).closest('tr').find('.lblConfigID').text())).chosen('destroy').chosen();;
                }
            });
           
            $('#btnsave').val('Update');
        };
        var CancelSelectionType = function () {
            $('#hdnid').val('0');
            $('#ddsettingtype').val('DETMIXCONFIG').chosen('destroy').chosen();;
            $('#ddlselectiontype').val('DETMIXCONFIG').chosen('destroy').chosen();;
            $('#btnsave').val('Save');
        }
        var UpdateStatus = function (el) {
            modelConfirmation('Are You Sure ?', ' Want To Deactive', 'Yes', 'No', function (res) {
                if (res) {
                    var Sta = 1;
                    if (!$(el).is(':checked')) {
                        Sta = 0;
                    }
                    var data = {
                        Status: Sta,
                        ID: $.trim($(el).closest('tr').find('.lblID').text()),
                    }
                    serverCall('IPDBill_PrintSetting.aspx/UpdateStatus', data, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.message, function () {
                            if (responseData.status) {

                            }
                            else {
                                if (!$(el).is(':checked')) 
                                    $(el).attr('checked', true);
                                else
                                    $(el).attr('checked', false);
                            }
                        });
                    });
                }
                else {
                    if (!$(el).is(':checked')) 
                        $(el).attr('checked', true);
                  else
                        $(el).attr('checked', false);
                }
            });
        }       
    </script>

    <script id="templateSearchDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdSearchDetails" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" id="tdName" >Config Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Print Type</th>
			<th class="GridViewHeaderStyle" scope="col" >Center Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Entry By</th>
			<th class="GridViewHeaderStyle" scope="col" >Entry Date</th>  
            <th class="GridViewHeaderStyle" scope="col" >Status</th> 
            <th class="GridViewHeaderStyle" scope="col" >Edit</th         
		</tr>
			</thead>
		<#
		var dataLength=templateData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
	
		for(var j=0;j<dataLength;j++)
		{
		objRow = templateData[j];
		#>
					<tr  data='<#= JSON.stringify(objRow) #>' id='<#=objRow.ID#>'>
					<td class="GridViewLabItemStyle textCeneter"><#=j+1#>
                           <label class="hidden lblID" ><#= objRow.ID #></label>
                         <label class="hidden lblPrintType" ><#= objRow.BillPrintType #></label>
                        <label class="hidden lblConfigID" ><#= objRow.ConfigID #></label>
                         <label class="hidden lblDisplayName" ><#= objRow.DisplayName #></label>
					</td>
                    <td class="GridViewLabItemStyle textCeneter"  style="text-align:left" >
                        <#
                        if(objRow.BillPrintType=="DETMIXDISP"){#> 
                        <#=objRow.DisplayName#>
                        <#} 
                        else{#>
                        <#=objRow.NAME#>
                        <#}
                        #>
                        </td>
					
					<td class="GridViewLabItemStyle textCeneter"><#=objRow.PrintType#></td>					
                    <td class="GridViewLabItemStyle textCeneter"><#=objRow.CentreName#></td>
					<td class="GridViewLabItemStyle textCeneter"><#=objRow.EntryBy#></td>
					<td class="GridViewLabItemStyle textCeneter"><#=objRow.EntryDate#></td>
					<td class="GridViewLabItemStyle textCeneter">
                        <input type="checkbox" id="chkStatus" name="chkStatus" onchange="UpdateStatus(this)" value='<#= objRow.IsActive #>' <#if(objRow.IsActive==1){#> checked="checked" <#}#>  />
                        </td>
                         <td class="GridViewLabItemStyle textCenter" ><img alt="" src="../../Images/edit.png" class="imgPlus"  style="cursor:pointer" onclick="EditDetails(this)"  /></td>                         
					</tr>
		<#}
		#>     
	 </table>
	</script>
</asp:Content>

