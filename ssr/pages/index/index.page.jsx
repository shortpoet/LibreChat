import { Provider } from 'react-redux';
import { store } from '~/store';
import { ThemeProvider } from '~/hooks/ThemeContext';
import App from '~/App';

export { Page }

function Page() {
  return (
    <>
      <Provider store={store}>
        <ThemeProvider>
        <App />
        </ThemeProvider>
      </Provider>
    </>
  )
}
