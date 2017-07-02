<%-- 
    Document   : PCarrera
    Created on : jun 17, 2017, 11:12:28 p.m.
    Author     : aa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Definición de Carreras</title>

    <!-- Bootstrap -->
    <link href="../Bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="../Estilos/EstGrid.css" rel="stylesheet">
    <link href="../Estilos/EstBtn.css" rel="stylesheet">

  </head>
  <body>
    
    <h1></h1>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="../Bootstrap/js/bootstrap.min.js"></script>

    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-default">
                <div class="panel-heading"><h1>Definición de Carreras</h1></div>
                    <div class="panel-body">
                    <form>  
                        <table border= "0" width="100%">
                        <tr>
                            <td>
                                <!-- En "ejemplo" hay que poner el en lace de la pagina Inicio en este caso -->
                                <a id="lnkIni" href="ejemplo"> Inicio </a>
                                >
                                Definición de Carrera
                                
                            </td>
                            <td style="text-align:right">
                                <button type="submit" id="BtnIng" class="BtnAlta"></button>
                            </td>
                        </tr>
                        </table>
                        <div class="panel panel-default">
                            <div class="panel-heading"><h10>Filtros</h10></div>
                                <div class="panel-body">
                                    <table border= "0" width="100%">
                                        <tr>
                                            <td>
                                                <div class="form-group">
                                                    <label for="InputCodigo">Código</label>
                                                    <input type="text" class="form-control" id="TxtCod" placeholder="Código">
                                                  </div>
                                            </td>
                                            <td class="margin">
                                                <div class="form-group">
                                                  <label for="InputNombre">Nombre</label>
                                                  <input type="text" class="form-control" id="TxtNom" placeholder="Nombre">
                                                </div>                                            
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="form-group">
                                                  <label for="InputFacultad">Facultad</label>
                                                  <input type="text" class="form-control" id="TxtFacu" placeholder="Facultad">
                                                </div>                                                
                                            </td>
                                            <td class="margin">
                                                <div class="form-group">
                                                  <label for="InputCategoria">Categoría</label>
                                                  <input type="text" class="form-control" id="TxtCate" placeholder="Categoría">
                                                </div>                                            
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>

                                            </td>
                                            <td style="text-align:right">
                                                <button type="submit" id="BtnBus" class="btn btn-default">Buscar</button>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                        </div>
                        
                        <div class="panel panel-default">
                            <div class="panel-heading"><h10>Lista de Carreras</h10></div>
                                <div class="panel-body">
                                    <table id="TblCar" class="table table-bordered">
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td>Código</td>
                                            <td>Nombre</td>
                                            <td>Facultad</td>
                                            <td>Categoría</td>
                                        </tr>
                                        <!-- Los tres registros no van, pero quedan de guía -->
                                        <tr>
                                            <td style="text-align:center"><button type="submit" class="btn_eli"></button></td>
                                            <td style="text-align:center"><button type="submit" class="btn_mod"></button></td>
                                            <td>1</td>
                                            <td>Analista Programador</td>
                                            <td>Ingeniería de Software</td>
                                            <td>AP</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align:center"><button type="submit" class="btn_eli"></button></td>
                                            <td style="text-align:center"><button type="submit" class="btn_mod"></button></td>
                                            <td>2</td>
                                            <td>Técnico en Gerencia</td>
                                            <td>Gerencia</td>
                                            <td>TG</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align:center"><button type="submit" class="btn_eli"></button></td>
                                            <td style="text-align:center"><button type="submit" class="btn_mod"></button></td>
                                            <td>3</td>
                                            <td>Diseño Web</td>
                                            <td>Diseño</td>
                                            <td>D</td>
                                        </tr>
                                    </table>
                                </div>
                        </div>
                  </form>
                </div>
            </div>
        </div>
    </div> 
  </body>
</html>